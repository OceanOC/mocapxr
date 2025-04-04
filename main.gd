extends Node3D

var sets = Bvhsets
var recording = true
var recframes = 0
var time_accum = 0.0  # Accumulated time

@onready var env = get_node("WorldEnvironment/AnimationPlayer")
@onready var vern = get_node("Label")
@onready var rectime = get_node("XROrigin3D/XRCamera3D/Recording Time")

@onready var LH = get_node("XROrigin3D/LHand")
@onready var RH = get_node("XROrigin3D/RHand")
@onready var Hed = get_node("XROrigin3D/XRCamera3D")


var template = """HIERARCHY
  ROOT chest
  {
	OFFSET 0.0 0.0 0.0
	CHANNELS 6 Xposition Yposition Zposition Zrotation Xrotation Yrotation
  {
	OFFSET 0.000000 0.000000 0.800000
	CHANNELS 6 Xrotation Yrotation Zrotation Xposition Yposition Zposition
  
  JOINT Head
	{
	  OFFSET 0.000000 0.000000 0.000000
	  CHANNELS 6 Xrotation Yrotation Zrotation Xposition Yposition Zposition
	}
JOINT hand_L
	{
	  OFFSET 0.000000 0.000000 0.000000
	  CHANNELS 6 Xrotation Yrotation Zrotation Xposition Yposition Zposition
	}
  JOINT hand_R
	{
	  OFFSET 0.000000 0.000000 0.000000
	  CHANNELS 6 Xrotation Yrotation Zrotation Xposition Yposition Zposition
	}
}
MOTION
Frames: 1
Frame Time: %s
""" % str(sets.bvhms / 1000)
#Frame Time: 0.0333333

var temp = template

var xr_interface: XRInterface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		recording = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		vern.set_text("OpenXR failed to start.\nPlease check if your HMD is connected and restart the application.")
		recording =false
	
	
	get_tree().set_auto_accept_quit(false)
	#print(template)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_accum += delta
	
	
	if time_accum >= (sets.bvhms / 1000):  # 33.33333 ms
		if recording:
			recframes += 1
			rectime.text = "%02d Frames" % recframes
			temp += do_motionframe()
		time_accum = 0.0  # Reset the accumulated time
	
	
	pass

func do_motionframe() -> String:
	# Shitty way to do this but it works for now
	var templat: String
	# Chest Bone
	templat = "0.0 0.0 0.0 0.0 0.0 0.0 "
	var hd = Hed.get_global_transform().basis.z
	var hd_pitch = -asin(hd.y)
	var hd_yaw = atan2(hd.x, -hd.z)
	
	# Head Bone
	templat += "%0.6f" % rad_to_deg(hd_pitch) + " %0.6f" % rad_to_deg(hd_yaw) + " %0.6f" % rad_to_deg(0) + " %0.6f" % Hed.global_position.x + " %0.6f" % Hed.global_position.y + " %0.6f" % Hed.global_position.z + " "
	
	# Left Hand Bone
	var lh = LH.get_global_transform().basis.z
	var lh_pitch = -asin(lh.y)
	var lh_yaw = atan2(lh.x, -lh.z)
	#templat += "%0.6f" % LH.rotation.x + " " + "%0.6f" % LH.rotation.y + " " + "%0.6f" % LH.rotation.z + " " + "%0.6f" % LH.global_position.x + " " + "%0.6f" % LH.global_position.y + " " + "%0.6f" % LH.global_position.z + " "
	templat += "%0.6f" % rad_to_deg(lh_pitch) + " %0.6f" % rad_to_deg(lh_yaw) + " %0.6f" % rad_to_deg(0) + " %0.6f" % LH.global_position.x + " %0.6f" % LH.global_position.y + " %0.6f" % LH.global_position.z + " "
	
	# Right Hand Bone
	var rh = RH.get_global_transform().basis.z
	var rh_pitch = -asin(rh.y)
	var rh_yaw = atan2(rh.x, -rh.z)
	#templat += "%0.6f" % RH.rotation.x + " " + "%0.6f" % RH.rotation.y + " " + "%0.6f" % RH.rotation.z + " " + "%0.6f" % RH.global_position.x + " " + "%0.6f" % RH.global_position.y + " " + "%0.6f" % RH.global_position.z + "\n"
	templat += "%0.6f" % rad_to_deg(rh_pitch) + " %0.6f" % rad_to_deg(rh_yaw) + " %0.6f" % rad_to_deg(0) + " %0.6f" % RH.global_position.x + " %0.6f" % RH.global_position.y + " %0.6f" % RH.global_position.z + "\n"
	return templat

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print(template)
		get_tree().quit() # default behavior


func _on_L_hand_button_pressed(name: String) -> void:
	if (name == "ax_button" || Input.is_action_pressed("endrecord")):
		var file = FileAccess.open(sets.bvhfile, FileAccess.WRITE)
		file.store_string(temp)
		
		
		get_tree().quit()
		#env.play("desat")
		#recording =false
		
	pass # Replace with function body.
