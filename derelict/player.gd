extends CharacterBody3D
const SPEED = 5.0
const GRAVITY = 12.0
const MOUSE_SENS = 0.003
const FLIP_TIME = 0.35
const OXYGEN_MAX = 100.0
const OXYGEN_DRAIN = 0.8  # per second
var oxygen := OXYGEN_MAX
var has_key := false
var orbs := 0
var beep_timer := 0.0
var scream_playing := false
var gravity_dir := Vector3.DOWN
var flipping := false
var flip_tween: Tween
var spawn_transform: Transform3D
@onready var cam: Camera3D = $Camera3D
@onready var oxygen_bar: ProgressBar = $"../hud/oxygenbar"
@onready var orb_label: Label = $"../hud/orbcounter"
func _ready():
	spawn_transform = global_transform
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	orb_label.text = "ORBS: 0"
	var fl = cam.get_node_or_null("SpotLight3D")
	if fl:
		fl.light_color = Settings.flashlight_color
	var v = get_node_or_null("../hud/visor")
	if v:
		v.color = Settings.visor_color
func _unhandled_input(event):
	if event is InputEventMouseMotion and not flipping and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_object_local(Vector3.UP, -event.relative.x * MOUSE_SENS)
		cam.rotation.x = clamp(cam.rotation.x - event.relative.y * MOUSE_SENS, -1.5, 1.5)
	if event.is_action_pressed("flip") and not flipping:
		flip_gravity()
func flip_gravity():
	var look := -cam.global_transform.basis.z
	var axis := look.abs().max_axis_index()
	var new_dir := Vector3.ZERO
	new_dir[axis] = sign(look[axis])
	set_gravity(new_dir)
func set_gravity(new_dir: Vector3):
	if new_dir == gravity_dir:
		return
	gravity_dir = new_dir
	up_direction = -gravity_dir
	var current_up := transform.basis.y
	var new_up := -gravity_dir
	var rot: Basis
	if current_up.dot(new_up) < -0.99:
		rot = Basis(transform.basis.z, PI)
	else:
		rot = Basis(Quaternion(current_up, new_up))
	var target := (rot * transform.basis).orthonormalized()
	var from_q := transform.basis.get_rotation_quaternion()
	var to_q := target.get_rotation_quaternion()
	create_tween().tween_property(cam, "rotation:x", 0.0, FLIP_TIME)
	if has_node("flipsound"):
		$flipsound.play()
	flipping = true
	flip_tween = create_tween()
	flip_tween.tween_method(
		func(t): transform.basis = Basis(from_q.slerp(to_q, t)),
		0.0, 1.0, FLIP_TIME)
	flip_tween.finished.connect(func(): flipping = false)
func add_orb():
	orbs += 1
	orb_label.text = "ORBS: " + str(orbs)
func play_sfx(sfx_name: String):
	var p = get_node_or_null("sfx/" + sfx_name)
	if p:
		p.play()
func update_fall_scream(_delta):
	var fall_depth := 0.0
	if gravity_dir == Vector3.DOWN and global_position.y < -2.0:
		fall_depth = -global_position.y - 2.0
	if fall_depth > 0.0:
		if not scream_playing and has_node("scream"):
			$scream.volume_db = 0.0
			$scream.play()
			scream_playing = true
		if scream_playing:
			$scream.volume_db = lerp(0.0, -40.0, clamp(fall_depth / 40.0, 0.0, 1.0))
	elif scream_playing:
		stop_scream()
func stop_scream():
	scream_playing = false
	if has_node("scream"):
		$scream.stop()
func respawn(refill := true):
	if flip_tween:
		flip_tween.kill()
	flipping = false
	global_transform = spawn_transform
	velocity = Vector3.ZERO
	gravity_dir = Vector3.DOWN
	up_direction = Vector3.UP
	cam.rotation = Vector3.ZERO
	if refill:
		oxygen = OXYGEN_MAX
	stop_scream()

func respawn_at(pos: Vector3):
	respawn(false)
	global_transform = Transform3D(Basis.IDENTITY, pos)

func _physics_process(delta):
	update_fall_scream(delta)
	oxygen -= OXYGEN_DRAIN * delta
	oxygen_bar.value = oxygen
	if oxygen < 20.0:
		beep_timer -= delta
		if beep_timer <= 0.0:
			play_sfx("lowo2")
			beep_timer = 1.0
	if oxygen <= 0:
		respawn()
		return
	if global_position.length() > 100.0:
		respawn(false)
		return
	var vertical := velocity.project(up_direction)
	if not is_on_floor():
		vertical += gravity_dir * GRAVITY * delta
	var input := Vector2.ZERO
	if not flipping:
		input = Input.get_vector("left", "right", "forward", "back")
	var dir := transform.basis * Vector3(input.x, 0, input.y)
	velocity = dir * SPEED + vertical
	move_and_slide()
