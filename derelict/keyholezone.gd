extends Area3D

@export var gate: Node3D
@onready var msg: Label = $"../hud/message"

func _ready():
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body.name != "player":
		return
	if body.has_key:
		body.play_sfx("unlock")
		msg.text = "GATE UNLOCKED"
		if gate:
			gate.queue_free()
		var kh = get_node_or_null("../keyhole")
		if kh:
			kh.queue_free()
	else:
		msg.text = "LOCKED - find the key"
	await get_tree().create_timer(2.0).timeout
	msg.text = ""
