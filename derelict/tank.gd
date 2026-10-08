extends Area3D

const REFILL = 30.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		body.oxygen = min(body.oxygen + REFILL, body.OXYGEN_MAX)
		queue_free()
