extends Area3D

@export var respawn_point := Vector3(0, 1.5, -11)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		body.call_deferred("respawn_at", respawn_point)
