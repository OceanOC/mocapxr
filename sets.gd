extends Node

var bvhfps = 30
var bvhms = 1000.0 / bvhfps
var bvhfile: String = "unnamed.bvh"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(bvhms)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
