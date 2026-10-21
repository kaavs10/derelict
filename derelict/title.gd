extends Control

@onready var menu = $VBoxContainer
@onready var controls_panel = $controlspanel
@onready var custom_panel = $customizepanel
@onready var fl_option: OptionButton = $customizepanel/vbox/flashlightoption
@onready var visor_option: OptionButton = $customizepanel/vbox/visoroption

var fl_names = ["White", "Cyan", "Red", "Green", "Amber"]
var fl_colors = [Color(1, 1, 1), Color(0.4, 0.9, 1), Color(1, 0.2, 0.2), Color(0.3, 1, 0.4), Color(1, 0.75, 0.3)]
var visor_names = ["None", "Blue", "Red", "Green", "Orange"]
var visor_colors = [Color(0, 0, 0, 0), Color(0.2, 0.5, 1, 0.15), Color(1, 0.1, 0.1, 0.15), Color(0.2, 1, 0.3, 0.15), Color(1, 0.6, 0.1, 0.15)]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	controls_panel.visible = false
	custom_panel.visible = false
	for n in fl_names:
		fl_option.add_item(n)
	for n in visor_names:
		visor_option.add_item(n)
	fl_option.selected = max(fl_colors.find(Settings.flashlight_color), 0)
	visor_option.selected = max(visor_colors.find(Settings.visor_color), 0)
	fl_option.item_selected.connect(func(i): Settings.flashlight_color = fl_colors[i])
	visor_option.item_selected.connect(func(i): Settings.visor_color = visor_colors[i])
	$VBoxContainer/playbutton.pressed.connect(_on_play)
	$VBoxContainer/controlsbutton.pressed.connect(_on_controls)
	$VBoxContainer/customizebutton.pressed.connect(_on_customize)
	$VBoxContainer/quitbutton.pressed.connect(_on_quit)
	$controlspanel/backbutton.pressed.connect(_on_back)
	$customizepanel/vbox/custombackbutton.pressed.connect(_on_back)

func _on_play():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_controls():
	menu.visible = false
	controls_panel.visible = true

func _on_customize():
	menu.visible = false
	custom_panel.visible = true

func _on_back():
	controls_panel.visible = false
	custom_panel.visible = false
	menu.visible = true

func _on_quit():
	get_tree().quit()
