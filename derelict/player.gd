extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 12.0
const MOUSE_SENS = 0.003

@onready var cam: Camera3D = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_object_local(Vector3.UP, -event.relative.x * MOUSE_SENS)
		cam.rotation.x = clamp(cam.rotation.x - event.relative.y * MOUSE_SENS, -1.5, 1.5)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	var input := Input.get_vector("left", "right", "forward", "back")
	var dir := transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	move_and_slide()
