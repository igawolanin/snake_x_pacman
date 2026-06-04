class_name Spawner extends Node2D

signal tail_added(tail:Tail)

@export var bounds:Bounds

var food_scene:PackedScene = preload("res://gameplay/food.tscn")
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")
var portal_scene:PackedScene = preload("res://gameplay/portal.tscn")
var wall_scene:PackedScene = preload("res://gameplay/wall.tscn")
var enemy_scene:PackedScene = preload("res://gameplay/monster.tscn")

var occupied_positions: Array[Vector2] = []

const PLAYER_START := Vector2.ZERO
const ENEMY_SAFE_DISTANCE := Global.GRID_SIZE * 5

func spawn_food():
	var spawn_point:Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.GRID_SIZE, bounds.x_max - Global.GRID_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.GRID_SIZE, bounds.y_max - Global.GRID_SIZE)
	
	spawn_point.x = floorf(spawn_point.x / Global.GRID_SIZE) * Global.GRID_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.GRID_SIZE) * Global.GRID_SIZE
	var food = food_scene.instantiate()
	food.position = get_free_grid_position()
	get_parent().add_child(food)

func spawn_tail(pos:Vector2):
	var tail:Tail = tail_scene.instantiate() as Tail
	tail.position = pos
	get_parent().add_child(tail)
	tail_added.emit(tail)
	
func spawn_walls(count: int) -> void:
	for i in count:
		var wall = wall_scene.instantiate()
		wall.position = get_free_grid_position()
		get_parent().add_child(wall)

func spawn_enemies(count: int) -> void:
	for i in count:
		var enemy := enemy_scene.instantiate() as Monster

		enemy.position = get_free_grid_position(true)

		enemy.x_min = bounds.x_min
		enemy.x_max = bounds.x_max
		enemy.y_min = bounds.y_min
		enemy.y_max = bounds.y_max

		get_parent().add_child(enemy)
		
func spawn_portal():
	var portal = portal_scene.instantiate()
	portal.position = get_free_grid_position()
	get_parent().add_child(portal)

func get_random_grid_position() -> Vector2:
	var spawn_point := Vector2.ZERO

	spawn_point.x = randf_range(
		bounds.x_min + Global.GRID_SIZE,
		bounds.x_max - Global.GRID_SIZE
	)

	spawn_point.y = randf_range(
		bounds.y_min + Global.GRID_SIZE,
		bounds.y_max - Global.GRID_SIZE
	)

	spawn_point.x = floorf(spawn_point.x / Global.GRID_SIZE) * Global.GRID_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.GRID_SIZE) * Global.GRID_SIZE

	return spawn_point

func reset_spawn_data() -> void:
	occupied_positions.clear()

func is_position_occupied(pos: Vector2) -> bool:
	return pos in occupied_positions

func is_too_close_to_player(pos: Vector2) -> bool:
	return pos.distance_to(PLAYER_START) < ENEMY_SAFE_DISTANCE

func get_free_grid_position(avoid_player: bool = false) -> Vector2:
	const MAX_ATTEMPTS := 100

	for i in MAX_ATTEMPTS:
		var pos := get_random_grid_position()

		if is_position_occupied(pos):
			continue

		if avoid_player and is_too_close_to_player(pos):
			continue

		occupied_positions.append(pos)
		return pos

	push_error("Could not find a free spawn position.")
	return Vector2.ZERO
