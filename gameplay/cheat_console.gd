extends CanvasLayer

@export var gameplay: Node
@export var spawner: Node

@onready var panel: Panel = $Panel
@onready var output: RichTextLabel = $Panel/VBoxContainer/Output
@onready var input: LineEdit = $Panel/VBoxContainer/Input

var cheat_mode: bool = false

signal cheat

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.hide()
	input.text_submitted.connect(_on_command_entered)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1:
			cheat_mode = not cheat_mode
			panel.visible = cheat_mode
			get_tree().paused = cheat_mode
			if cheat_mode:
				input.clear()
				input.call_deferred("grab_focus")
			else:
				input.release_focus()
			get_viewport().set_input_as_handled()


func _on_command_entered(command: String) -> void:
	var args = command.strip_edges().to_lower().split(" ", false)
	if args.is_empty():
		return
	match args[0]:
		"help":
			print_help()
			print("help command")
		"food":
			spawner.call_deferred("spawn_food")
			print_message("Food spawned")
			print("food spawn command")
		"god":
			gameplay.invincible = not gameplay.invincible
			print_message("Attempted to spawn power-up.")
			print("powerup command")
		"level":
			if args.size() > 1 and args[1].is_valid_int():
				var new_level = int(args[1])
				print("level change command")
				if new_level >= 1 and new_level < 5:
					gameplay.level = new_level
					gameplay.start_next_level()
					print_message("Changed to level " + str(new_level))
				else:
					print_message("Level must be between 1 and 4.")
			else:
				print_message("Usage: level <1-4>")
		_:
			print_message("Unknown command. Type 'help'.")
	input.clear()
	input.grab_focus()
	input.clear()
	cheat_mode = false
	panel.hide()
	get_tree().paused = false
	input.release_focus()


func print_help() -> void:
	print_message("Available cheats:")
	print_message("food - Spawn food")
	print_message("powerup - Attempt to spawn a power-up")
	print_message("god - Toggle invincibility")
	print_message("level 1-4 - Change level")


func print_message(message: String) -> void:
	output.append_text(message + "\n")
