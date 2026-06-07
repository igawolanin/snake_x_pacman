class_name GameOver extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_play_button_pressed() -> void:
	get_tree().call_deferred(
			"change_scene_to_file",
			"res://gameplay/Gameplay.tscn"
		)	

func _on_quit_button_pressed() -> void:
	get_tree().call_deferred(
			"change_scene_to_file",
			"res://menus/start.tscn"
		)

func rock_death_anim() -> void:
	print("rock")
	anim.play("rock")

func palm_death_anim() -> void:
	print("palm")
	anim.play("palm")

func monster_death_anim() -> void:
	anim.play("monster")
	print("monster")

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
