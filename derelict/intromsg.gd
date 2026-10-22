extends Label
func _ready():
	modulate.a = 0.0
	visible = true
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.6)   # fade in
	t.tween_interval(3.5)                             # hold
	t.tween_property(self, "modulate:a", 0.0, 0.8)   # fade out
	t.tween_callback(func(): visible = false) 
