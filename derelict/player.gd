extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 12.0
const MOUSE_SENS = 0.003

var gravity_dir := Vector3.DOWN

@onready var cam: Camera3D = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_object_local(Vector3.UP, -event.relative.x * MOUSE_SENS)
		cam.rotation.x = clamp(cam.rotation.x - event.relative.y * MOUSE_SENS, -1.5, 1.5)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("flip"):
		flip_gravity()

func flip_gravity():
	# Which way is the camera looking, snapped to the nearest axis?
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
		rot = Basis(transform.basis.z, PI)  # full 180 degree flip
	else:
		rot = Basis(Quaternion(current_up, new_up))
	transform.basis = (rot * transform.basis).orthonormalized()

func _physics_process(delta):
	var vertical := velocity.project(up_direction)
	if not is_on_floor():
		vertical += gravity_dir * GRAVITY * delta
	var input := Input.get_vector("left", "right", "forward", "back")
	var dir := transform.basis * Vector3(input.x, 0, input.y)
	velocity = dir * SPEED + vertical
	move_and_slide()
