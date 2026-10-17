extends Node2D

const ROCK_TEXTURES := [
	preload("res://gameplay/sprites/obstacles/rock_1.png"),
	preload("res://gameplay/sprites/obstacles/rock_2.png"),
	preload("res://gameplay/sprites/obstacles/rock_3.png"),
	preload("res://gameplay/sprites/obstacles/rock_4.png"),
	preload("res://gameplay/sprites/obstacles/rock_5.png"),
	preload("res://gameplay/sprites/obstacles/rock_6.png"),
	preload("res://gameplay/sprites/obstacles/palm.png")
]
var is_rock:bool = true

func _ready() -> void:
	$Sprite2D.texture = ROCK_TEXTURES.pick_random()
	if $Sprite2D.texture == ROCK_TEXTURES[6]:
		$Sprite2D.scale = Vector2(0.5,0.5)
		$Sprite2D.offset.y = -80
		is_rock = false
		
