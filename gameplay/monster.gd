class_name Monster
extends Area2D

@export var move_vertical: bool = true
@export var step_size: int = Global.GRID_SIZE

var x_max: float
var x_min: float
var y_max: float
var y_min: float

var direction: int = 1
var last_position: Vector2

func _ready() -> void:
	move_vertical = randi_range(0,1)

func move_enemy() -> void:
	last_position = position
	
	if move_vertical:
		var new_y = position.y + step_size * direction
		if new_y > y_max or new_y < y_min:
			direction *= -1
			new_y = position.y + step_size * direction
		position.y = new_y
	else:
		var new_x = position.x + step_size * direction
		if new_x > x_max or new_x < x_min:
			direction *= -1
			new_x = position.x + step_size * direction
		position.x = new_x
