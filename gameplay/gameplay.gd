class_name Gameplay extends Node2D


const gameover_scene:PackedScene = preload("res://menus/game_over.tscn")
var gameover_menu:GameOver
const pausemenu_scene:PackedScene = preload("res://menus/pause_menu.tscn")
var pause_menu:PauseMenu

@onready var head : Head = %Head as Head
@onready var bounds:Bounds = %Bounds as Bounds
@onready var spawner:Spawner = %Spawner as Spawner

var move_dir:Vector2 = Vector2.RIGHT # Vector2(1,0)
var time_between_moves : float = 1000.0
var time_since_last_move : float = 0
var speed:float = 5000.0
var snake_parts:Array[SnakePart] = []
var level:int = 1
var eat_count:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.food_eaten.connect(_on_food_eaten)
	head.collision_with_portal.connect(_on_portal_collision)
	head.collision_with_tail.connect(_on_tail_colliding)
	spawner.tail_added.connect(_on_tail_added)
	spawner.spawn_food()
	snake_parts.push_back(head)


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
		check_monster_collision()
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
		
func check_monster_collision() -> void:
	for enemy in get_tree().get_nodes_in_group("monster"):
		# normalna kolizja - to samo pole
		if enemy.position == head.position:
			_on_monster_colliding()
			return
		
		# zamiana miejsc w tym samym ticku
		if enemy.last_position == head.position and enemy.position == head.last_position:
			_on_monster_colliding()
			return
		
func _on_food_eaten():
	print("food eaten")
	eat_count += 1
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)
	if (snake_parts.size() == Global.LENGTH_NEEDED_FOR_PORTAL):
		spawner.call_deferred("spawn_portal")
	else: 
		spawner.call_deferred("spawn_food")
		speed += 500
	
func _on_tail_added(tail:Tail):
	snake_parts.push_back(tail)
	
func _on_tail_colliding():
	print("game over")
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		
func _on_monster_colliding():
	print("game over")
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		
func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()
		
func pause_game():
	if not pause_menu:
		pause_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pause_menu)

func _on_portal_collision():
	print("game won")
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file","res://menus/start.tscn")
