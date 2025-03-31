extends Node2D

@onready var fdiag = get_node("FileDialog")
@onready var lwin = get_node("Window")
@onready var recfps_spinbox = get_node("Sets/Settings/HBoxContainer/RecFPS/VBoxContainer/SpinBox")
var fps = 30
var sets = Bvhsets

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vid_settings = CfgHandler.load_output_settings()
	recfps_spinbox.value = vid_settings.recfps
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	fdiag.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	sets.bvhfile = path
	sets.bvhfps = fps
	sets.bvhms = 1000.0 / fps
	fdiag.visible = false
	get_tree().change_scene_to_file("res://main.tscn")
	


func _on_spin_box_value_changed(value: float) -> void:
	CfgHandler.save_output_setting("recfps", value)
	fps = value


func _on_license_button_pressed() -> void:
	lwin.visible = true


func _on_window_close_requested() -> void:
	lwin.visible = false


func _on_file_dialog_close_requested() -> void:
	fdiag.visible = false


func _on_save_setting_pressed() -> void:
	CfgHandler.save_cfg()
	pass # Replace with function body.
