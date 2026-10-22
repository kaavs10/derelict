extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	$vbox/resumebutton.pressed.connect(_resume)
	$vbox/menubutton.pressed.connect(_to_menu)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_resume()
		else:
			_pause()

func _pause():
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _resume():
	visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _to_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title.tscn")
