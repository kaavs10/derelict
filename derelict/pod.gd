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
	tw.tween_property(door, "position:y", 4.8, 1.5)  # door slides up
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
	var white = get_node_or_null("../hud/fade")
	if white:
		var tw = create_tween()
		tw.tween_property(white, "color:a", 1.0, 1.5)
		await tw.finished
	var label = get_node_or_null("../hud/endmsg")
	if label:
		label.visible = true
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_file("res://title.tscn")
