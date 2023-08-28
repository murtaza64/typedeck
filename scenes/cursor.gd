extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var polygon = get_node("Polygon2D")
	polygon.color = Catppuccin.text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
