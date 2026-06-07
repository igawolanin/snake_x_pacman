extends Button

var original_position: Vector2
var shake_time := 0.15

func _ready() -> void:
	original_position = position

func _on_mouse_entered() -> void:
	var tween := create_tween()

	for i in 6:
		tween.tween_property(
			self,
			"position",
			original_position + Vector2(randf_range(-4, 4), 0),
			shake_time / 6.0
		)

	tween.tween_property(self, "position", original_position, 0.02)

func _on_mouse_exited() -> void:
	position = original_position
