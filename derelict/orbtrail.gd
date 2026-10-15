extends Node3D

var orb_scene = preload("res://orb.tscn")

# Room 1: right-hand trail (the left side is mirrored automatically)
var room1_points = [
	Vector3(0, 1, 8), Vector3(2, 1, 7), Vector3(4, 1, 6),
	Vector3(6, 1, 5), Vector3(8, 1, 4),
	Vector3(8.5, 2, 3), Vector3(8.5, 2, 1), Vector3(8.5, 2, -1),
	Vector3(8.5, 2, -3), Vector3(8.5, 2, -5),
]

func spawn_orb(p: Vector3):
	var o = orb_scene.instantiate()
	add_child(o)
	o.global_position = p

func _ready():
	# Room 1: right path and mirrored left path
	for p in room1_points:
		spawn_orb(p)
		if p.x != 0:
			spawn_orb(Vector3(-p.x, p.y, p.z))
	# Room 2: a trail along the ceiling, through the window
	var xs = [0.0, -1.5, 0.0, 1.5]
	for i in range(8):
		spawn_orb(Vector3(xs[i % 4], 3, -13 - i * 2))
