extends Node3D

@export var reactor: Area3D

@onready var door: CSGBox3D = $door
@onready var podlight: OmniLight3D = $podlight
@onready var zone: Area3D = $podzone
@onready var msg: Label = $"../hud/message"

var unlocked := false
var finished := false

func _ready():
	podlight.light_color = Color(1, 0.1, 0.1)
	if reactor:
		reactor.shutdown.connect(_on_shutdown)
	zone.body_entered.connect(_on_zone_entered)

func _on_shutdown():
	unlocked = true
	podlight.light_color = Color(0.2, 1, 0.3)
	var tw = create_tween()
	tw.tween_property(door, "position:y", 5.5, 1.5)  # door slides up
	tw.tween_callback(func(): door.use_collision = false)

func _on_zone_entered(body):
	if body.name != "player" or finished:
		return
	if not unlocked:
		msg.text = "POD LOCKED - SHUT DOWN THE REACTOR"
		await get_tree().create_timer(2.0).timeout
		msg.text = ""
		return
	finished = true
	win()

func win():
	var hud = get_node("../hud")
	# stop the player so oxygen can't run out during the ending
	var player = get_node_or_null("../player")
	if player:
		player.set_physics_process(false)

	# full-screen white fade
	var white = ColorRect.new()
	white.color = Color(1, 1, 1, 0)
	white.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(white)
	white.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var tw = create_tween()
	tw.tween_property(white, "color:a", 1.0, 1.8)
	await tw.finished

	# centered message
	var label = Label.new()
	label.text = "YOU ESCAPED!"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ls = LabelSettings.new()
	ls.font_size = 96
	ls.font_color = Color(0.05, 0.1, 0.25)
	label.label_settings = ls
	label.modulate.a = 0.0
	hud.add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var tw2 = create_tween()
	tw2.tween_property(label, "modulate:a", 1.0, 1.0)

	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://title.tscn")
