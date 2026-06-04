extends Control

@onready var exit:Button = %ExitButton as Button

func _on_exit_pressed() -> void:
	print("EXIT PRESSED")
	get_tree().quit()
	


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gameplay/Gameplay.tscn")
