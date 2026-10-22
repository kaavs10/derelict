extends Area3D

@onready var label: Label = $"../hud/lavamsg"
var shown := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name != "player" or shown:
		return
	shown = true
	label.modulate.a = 1.0
	label.visible = true
	await get_tree().create_timer(2.5).timeout
	var t = create_tween()
	t.tween_property(label, "modulate:a", 0.0, 0.7)
	await t.finished
	label.visible = false
