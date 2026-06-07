extends Control

@onready var girl: Node2D = $CanvasLayer/SnakeGirl
@onready var anim: AnimationPlayer = $AnimationPlayer

var right:bool = true
var screen_width: float = 1600.0

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gameplay/Gameplay.tscn")

func _ready() -> void:
	play_snake_girl_anim()
	var timer := Timer.new()
	timer.wait_time = 15.0
	timer.autostart = true
	timer.timeout.connect(play_snake_girl_anim)
	add_child(timer)

func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func play_snake_girl_anim() -> void: 
	right = !right
	girl.position.y = randi_range(600, 854)
	if !right:
		anim.play("snake-girl-mirrored")
	else:
		anim.play("snake-girl")


func _on_quit_button_2_pressed() -> void:
	get_tree().quit()
