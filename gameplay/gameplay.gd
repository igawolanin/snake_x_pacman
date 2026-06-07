class_name Gameplay extends Node2D


const gameover_scene:PackedScene = preload("res://menus/game_over.tscn")
var gameover_menu:GameOver
const pausemenu_scene:PackedScene = preload("res://menus/pause_menu.tscn")
var pause_menu:PauseMenu
const gamewin_scene:PackedScene = preload("res://menus/game_win.tscn")
var gamewin:GameWin
const tutorial_scene:PackedScene = preload("res://menus/tutorial.tscn")
var tutorial:CanvasLayer

@onready var head : Head = %Head as Head
@onready var bounds:Bounds = %Bounds as Bounds
@onready var spawner:Spawner = %Spawner as Spawner
@onready var score:CanvasLayer = $Score as CanvasLayer

var move_dir:Vector2 = Vector2.RIGHT # Vector2(1,0)
var time_between_moves : float = 1000.0
var time_since_last_move : float = 0
var speed:float = 5000.0
var snake_parts:Array[SnakePart] = []
var level:int = 1
var eat_count:int = 0
var death:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.food_eaten.connect(_on_food_eaten)
	head.collision_with_portal.connect(_on_portal_collision)
	head.collision_with_tail.connect(_on_collision)
	head.collision_with_wall.connect(_on_collision)
	spawner.tail_added.connect(_on_tail_added)
	spawner.spawn_food()
	snake_parts.push_back(head)
	tutorial = tutorial_scene.instantiate() as CanvasLayer
	add_child(tutorial)
	tutorial.layer = 20
	spawner.spawn_enemies(1)
	spawner.spawn_walls(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	var new_dir: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		new_dir = Vector2.UP # (0,1)
		
	elif Input.is_action_pressed("ui_down"):
		new_dir = Vector2.DOWN # (0,-1)
		
	elif Input.is_action_pressed("ui_left"):
		new_dir = Vector2.LEFT # (-1,0)
		
	elif Input.is_action_pressed("ui_right"):
		new_dir = Vector2.RIGHT # (1,0)
		
	if new_dir + move_dir != Vector2.ZERO and new_dir != Vector2.ZERO:
		move_dir = new_dir
		
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()
		
func _physics_process(delta: float) -> void:
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		check_enemy_collision()
		check_wall_collision()
		update_enemies()
		time_since_last_move = 0
		

func update_snake():
	var new_pos:Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_pos = bounds.wrap_vector(new_pos)
	head.move_to(new_pos)
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)
		
func update_enemies():
	for enemy in get_tree().get_nodes_in_group("monster"):
		enemy.move_enemy()

func check_enemy_collision() -> void:
	for object in get_tree().get_nodes_in_group("monster"):
		if object.position == head.position or (object.last_position == head.position and object.position == head.last_position):
			death = 1
			print("mo is 1")
			_on_collision()
			return
		
func check_wall_collision() -> void:
	for object in get_tree().get_nodes_in_group("wall"):
		if object.position == head.position:
			if object.is_rock:
				death = 3
			else:
				death = 2
			_on_collision()
			return
		
func _on_food_eaten():
	print("food eaten")
	eat_count += 1
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)
	if (snake_parts.size() == Global.LENGTH_NEEDED_FOR_PORTAL):
		if level == Global.MAX_LEVEL:
			spawner.call_deferred("spawn_portal", true)
		else:
			spawner.call_deferred("spawn_portal", false)
	else: 
		spawner.call_deferred("spawn_food")
		speed += 500
	score.change_score(eat_count)
	
func _on_tail_added(tail:Tail):
	snake_parts.push_back(tail)
	
func _on_collision():
	print("game over")
	if tutorial:
		tutorial.queue_free()
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
	if death == 1:
		gameover_menu.anim.play("monster")
	elif death == 2:
		gameover_menu.anim.play("palm")
	elif death == 3:
		gameover_menu.anim.play("rock")
		
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()
		
func pause_game():
	if not pause_menu:
		pause_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pause_menu)

func _on_portal_collision():
	level += 1

	if level > Global.MAX_LEVEL:
		gamewin = gamewin_scene.instantiate() as GameWin
		add_child(gamewin)
		return

	call_deferred("start_next_level")

func start_next_level() -> void:
	print("Starting level ", level)
	if level == 2:
		tutorial.queue_free()

	reset_snake()
	clear_level()
	score.change_score(0)
	spawner.reset_spawn_data()
	spawner.spawn_food()
	spawner.spawn_enemies(level)
	spawner.spawn_walls(level)

func reset_snake() -> void:
	move_dir = Vector2.RIGHT
	time_since_last_move = 0
	speed = 5000.0
	eat_count = 0

	head.position = Vector2.ZERO
	head.last_position = head.position

	# Remove all tail segments
	for i in range(1, snake_parts.size()):
		snake_parts[i].queue_free()

	snake_parts.clear()
	snake_parts.push_back(head)

func clear_level() -> void:
	for node in get_tree().get_nodes_in_group("monster"):
		node.queue_free()

	for node in get_tree().get_nodes_in_group("wall"):
		node.queue_free()

	for node in get_tree().get_nodes_in_group("food"):
		node.queue_free()

	for node in get_tree().get_nodes_in_group("portal"):
		node.queue_free()
