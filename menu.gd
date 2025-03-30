extends Node2D

@onready var fdiag = get_node("FileDialog")
@onready var lwin = get_node("Window")
var fps = 30
var sets = Bvhsets

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	fdiag.visible = true
	pass # Replace with function body.


func _on_file_dialog_file_selected(path: String) -> void:
	sets.bvhfile = path
	sets.bvhfps = fps
	sets.bvhms = 1000.0 / fps
	fdiag.visible = false
	get_tree().change_scene_to_file("res://main.tscn")
	
	pass # Replace with function body.


func _on_spin_box_value_changed(value: float) -> void:
	fps = value
	pass # Replace with function body.


func _on_license_button_pressed() -> void:
	lwin.visible = true
	pass # Replace with function body.


func _on_window_close_requested() -> void:
	lwin.visible = false
	pass # Replace with function body.


func _on_file_dialog_close_requested() -> void:
	fdiag.visible = false
	pass # Replace with function body.
