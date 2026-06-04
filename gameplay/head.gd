class_name Head extends SnakePart

signal food_eaten
signal collision_with_tail
signal collision_with_portal

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("food"):
		food_eaten.emit()
		area.call_deferred("queue_free")
	elif area.is_in_group("portal"):
		collision_with_portal.emit()
	else:
		collision_with_tail.emit()
