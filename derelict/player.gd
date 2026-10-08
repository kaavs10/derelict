extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 12.0
const MOUSE_SENS = 0.003
const FLIP_TIME = 0.35
const OXYGEN_MAX = 100.0
const OXYGEN_DRAIN = 1.5  # per second
var oxygen := OXYGEN_MAX

@onready var oxygen_bar: ProgressBar = $"../hud/oxygenbar"
var gravity_dir := Vector3.DOWN
var flipping := false
var flip_tween: Tween
var spawn_transform: Transform3D

@onready var cam: Camera3D = $Camera3D

func _ready():
	spawn_transform = global_transform
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and not flipping:
		rotate_object_local(Vector3.UP, -event.relative.x * MOUSE_SENS)
		cam.rotation.x = clamp(cam.rotation.x - event.relative.y * MOUSE_SENS, -1.5, 1.5)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
	flipping = true
	flip_tween = create_tween()
	flip_tween.tween_method(
		func(t): transform.basis = Basis(from_q.slerp(to_q, t)),
		0.0, 1.0, FLIP_TIME)
	flip_tween.finished.connect(func(): flipping = false)

func respawn():
	if flip_tween:
		flip_tween.kill()
	flipping = false
	global_transform = spawn_transform
	velocity = Vector3.ZERO
	gravity_dir = Vector3.DOWN
	up_direction = Vector3.UP
	cam.rotation = Vector3.ZERO

func _physics_process(delta):
	oxygen -= OXYGEN_DRAIN * delta
	oxygen_bar.value = oxygen
	if oxygen <= 0:
		respawn()
		oxygen = OXYGEN_MAX
	if global_position.length() > 40.0:
		respawn()
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
