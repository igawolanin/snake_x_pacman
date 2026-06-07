extends CanvasLayer

var max_score:int = Global.LENGTH_NEEDED_FOR_PORTAL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "0/0"

func change_score(current_score:int) -> void:
	$Label.text = str(current_score) + "/" + str(max_score)
