extends Area3D

@onready var msg: Label = $"../hud/message"

func _process(delta):
	rotate_y(2.0 * delta)

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		body.has_key = true
		msg.text = "You got the key!"
		visible = false
		set_deferred("monitoring", false)
		await get_tree().create_timer(2.0).timeout
		msg.text = ""
		queue_free()
