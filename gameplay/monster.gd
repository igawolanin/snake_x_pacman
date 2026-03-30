class_name Monster
extends Area2D

@onready var upper_left: Marker2D = %UpperLeft
@onready var lower_right: Marker2D = %LowerRight

@export var step_size: int = Global.GRID_SIZE
@export var move_vertical: bool = true

var x_max: float
var x_min: float
var y_max: float
var y_min: float

var direction: int = 1
var last_position: Vector2

func _ready() -> void:
	x_min = upper_left.position.x
	x_max = lower_right.position.x
	y_min = upper_left.position.y
	y_max = lower_right.position.y
	last_position = position

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
