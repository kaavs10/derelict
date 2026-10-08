extends OmniLight3D

var base_energy := 2.0
var timer := 0.0

func _ready():
	base_energy = light_energy

func _process(delta):
	timer -= delta
	if timer <= 0.0:
		# pick a new random brightness and how long to hold it
		if randf() < 0.3:
			light_energy = 0.0                      # blackout
		else:
			light_energy = base_energy * randf_range(0.3, 1.0)
		timer = randf_range(0.03, 0.25)
