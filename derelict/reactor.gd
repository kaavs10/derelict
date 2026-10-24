extends Area3D

signal shutdown

@export var required_orbs := 20

@onready var msg: Label = $"../hud/message"
@onready var core: CSGSphere3D = $core
@onready var light: OmniLight3D = $light

var done := false
var busy := false
var mat := StandardMaterial3D.new()
var t := 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	mat.albedo_color = Color(1, 0.5, 0.1)
	mat.emission_enabled = true
	mat.emission = Color(1, 0.45, 0.05)
	mat.emission_energy_multiplier = 3.0
	core.material = mat

func _process(delta):
	if done:
		return
	t += delta
	core.rotate_y(1.5 * delta)
	light.light_energy = 3.0 + sin(t * 3.0) * 1.5  # pulsing glow

func _on_body_entered(body):
	if body.name != "player" or done or busy:
		return
	if body.orbs < required_orbs:
		busy = true
		msg.text = "NEED %d MORE ORBS TO POWER DOWN" % (required_orbs - body.orbs)
		await get_tree().create_timer(2.5).timeout
		msg.text = ""
		busy = false
		return
	done = true
	shutdown.emit()
	msg.text = "REACTOR SHUT DOWN"
	if body.has_method("play_sfx"):
		body.play_sfx("unlock")
	# core dims and the light turns emergency red
	var tw = create_tween()
	tw.tween_property(mat, "emission_energy_multiplier", 0.2, 1.5)
	light.light_color = Color(1, 0.1, 0.1)
	light.light_energy = 4.0
	await get_tree().create_timer(3.0).timeout
	msg.text = ""
