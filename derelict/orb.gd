extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.8, 0.2)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.7, 0.1)
	mat.emission_energy_multiplier = 2.0
	$CSGSphere3D.material = mat

func _process(delta):
	rotate_y(3.0 * delta)

func _on_body_entered(body):
	if body.name == "player":
		body.add_orb()
		queue_free()
