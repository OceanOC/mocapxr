extends Node

var config = ConfigFile.new()
const config_filepath = "user://config.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!FileAccess.file_exists(config_filepath)):
		config.set_value("output", "recfps",  30)
		config.set_value("gui", "showrectimer",  false)
		
		config.save(config_filepath)
	else:
		config.load(config_filepath)
	pass # Replace with function body.

func save_cfg():
	config.save(config_filepath)

func save_output_setting(key: String, value):
	config.set_value("output", key, value)

func load_output_settings():
	var out_settings = {}
	for key in config.get_section_keys("output"):
		out_settings[key] = config.get_value("output", key)
	return out_settings
	
func save_gui_setting(key: String, value):
	config.set_value("gui", key, value)

func load_gui_settings():
	var out_settings = {}
	for key in config.get_section_keys("gui"):
		out_settings[key] = config.get_value("gui", key)
	return out_settings
