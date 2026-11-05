extends Node2D

const LEVEL_TEXTURES := {
	1: [ #dungeon
		preload("res://gameplay/sprites/obstacles/mineral2q.png"),
		preload("res://gameplay/sprites/obstacles/mineral3.png"),
		preload("res://gameplay/sprites/obstacles/rock_1.png"),
		preload("res://gameplay/sprites/obstacles/rock_3.png"),
		preload("res://gameplay/sprites/obstacles/mineral.png"),
		preload("res://gameplay/sprites/furniture/barrel.png")
	],

	2: [ #manor
		preload("res://gameplay/sprites/furniture/bed.png"),
		preload("res://gameplay/sprites/furniture/bookshelf.png"),
		preload("res://gameplay/sprites/furniture/chimney.png"),
		preload("res://gameplay/sprites/furniture/fireplace.png"),
		preload("res://gameplay/sprites/furniture/glass.png"),
		preload("res://gameplay/sprites/furniture/globe.png"),
		preload("res://gameplay/sprites/furniture/round_table.png"),
		preload("res://gameplay/sprites/furniture/sofa.png"),
		preload("res://gameplay/sprites/furniture/table.png"),
		preload("res://gameplay/sprites/furniture/shelf.png")
	],

	3: [ #chapel
		preload("res://gameplay/sprites/obstacles/rock_5.png"),
		preload("res://gameplay/sprites/obstacles/rock_6.png"),
		preload("res://gameplay/sprites/church/ambona.png"),
		preload("res://gameplay/sprites/church/angel.png"),
		preload("res://gameplay/sprites/church/fountain.png"),
		preload("res://gameplay/sprites/church/mosaic.png"),
		preload("res://gameplay/sprites/church/piano.png"),
		preload("res://gameplay/sprites/furniture/candle.png")
	],

	4: [ #beach
		preload("res://gameplay/sprites/obstacles/rock_1.png"),
		preload("res://gameplay/sprites/obstacles/rock_2.png"),
		preload("res://gameplay/sprites/obstacles/rock_3.png"),
		preload("res://gameplay/sprites/obstacles/rock_4.png"),
		preload("res://gameplay/sprites/obstacles/rock_5.png"),
		preload("res://gameplay/sprites/obstacles/rock_6.png"),
		preload("res://gameplay/sprites/obstacles/palm.png")
	]
}

var is_rock:bool = true

func set_wall_texture(level: int) -> void:
	if not LEVEL_TEXTURES.has(level):
		push_error("No wall textures found for level: " + str(level))
		return
	var textures: Array = LEVEL_TEXTURES[level]
	var selected_texture: Texture2D = textures.pick_random()
	$Sprite2D.texture = selected_texture
	$Sprite2D.scale = Vector2.ONE
	$Sprite2D.offset = Vector2.ZERO
	is_rock = true
	
	if "palm" in selected_texture.resource_path:
		$Sprite2D.scale = Vector2(0.5, 0.5)
		$Sprite2D.offset.y = -80
		is_rock = false
