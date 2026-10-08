extends Area3D

@onready var msg: Label = $"../hud/message"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		msg.text = "YOU ESCAPED!"
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
