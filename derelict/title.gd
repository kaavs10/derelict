extends Control

@onready var menu = $VBoxContainer
@onready var controls_panel = $controlspanel

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	controls_panel.visible = false
	$VBoxContainer/playbutton.pressed.connect(_on_play)
	$VBoxContainer/controlsbutton.pressed.connect(_on_controls)
	$VBoxContainer/quitbutton.pressed.connect(_on_quit)
	$controlspanel/backbutton.pressed.connect(_on_back)

func _on_play():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_controls():
	menu.visible = false
	controls_panel.visible = true

func _on_back():
	controls_panel.visible = false
	menu.visible = true

func _on_quit():
	get_tree().quit()
