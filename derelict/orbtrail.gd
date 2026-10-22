extends Node3D
var orb_scene = preload("res://orb.tscn")
# Room 1: right-hand trail (left side is mirrored automatically)
var room1_points = [
	Vector3(0, 1, 8), Vector3(2, 1, 7), Vector3(4, 1, 6),
	Vector3(6, 1, 5), Vector3(8, 1, 4),
	Vector3(9.3, 2, 3), Vector3(9.3, 2, 1), Vector3(9.3, 2, -1),
	Vector3(9.3, 2, -3), Vector3(9.3, 2, -5),
]
# Room 3: near floor, up the wall across the gap, down to the far floor
var room3_points = [
	Vector3(0, 1, -32), Vector3(2, 1, -33), Vector3(4, 1, -34),
	Vector3(6, 1, -35),
	Vector3(9.3, 2, -36), Vector3(9.3, 2, -38), Vector3(9.3, 2, -40),
	Vector3(9.3, 2, -42),
	Vector3(6, 1, -44), Vector3(4, 1, -45), Vector3(2, 1, -46),
]
func spawn_orb(p: Vector3):
	var o = orb_scene.instantiate()
	add_child(o)
	o.global_position = p
func _ready():
	# Room 1
	for p in room1_points:
		spawn_orb(p)
		if p.x != 0:
			spawn_orb(Vector3(-p.x, p.y, p.z))
	# Room 2: left wall row, ceiling row (zigzag), right wall row
	var xs = [0.0, -1.5, 0.0, 1.5]
	for i in range(8):
		var z = -13 - i * 2
		if z == -19 or z == -21:
			continue  # skip orbs that would sit inside the barrier wall
		spawn_orb(Vector3(xs[i % 4], 3.8, z))  # ceiling zigzag
		spawn_orb(Vector3(-9.3, 3, z))         # left wall
		spawn_orb(Vector3(9.3, 3, z))          # right wall
	for p in room3_points:
		spawn_orb(p)
		if p.x != 0:
			spawn_orb(Vector3(-p.x, p.y, p.z))
	spawn_orb(Vector3(0, 1, -44))
	spawn_orb(Vector3(0, 1, -48))
