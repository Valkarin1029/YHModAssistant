tool
extends Tabs

onready var YHAGlobal = find_parent("YH Mod Assistant")
onready var DEFUALT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")

var current_mod_path = null

var export_path = ""

var export_name = ""
var previous_export_name = ""

var mod_info

func _ready():
	YHAGlobal = find_parent("YH Mod Assistant")
	if not YHAGlobal == null:
		current_mod_path = YHAGlobal.current_mod_path
		YHAGlobal.connect("load_mod_info", self, "_load_mod_info")
	
	$"%Export Path".placeholder_text = DEFUALT_EXPORT_PATH
	

func _load_mod_info():
	YHAGlobal = find_parent("YH Mod Assistant")
	current_mod_path = YHAGlobal.current_mod_path
	$"%ModFolderPath".text = current_mod_path
	
	var meta_data_path = current_mod_path.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	
	if dir.file_exists(meta_data_path):
		file.open(meta_data_path,File.READ)
		var contents = JSON.parse(file.get_as_text()).result
		file.close()
		mod_info = contents

func _on_SelectExportPath_pressed():
	$"%SelectExportFolder".popup()

func _on_SelectExportFolder_dir_selected(dir):
	export_path = dir
	$"%Export Path".text = dir

func _on_Export_Path_text_changed(new_text):
	export_path = new_text

func _on_FileName_text_changed(new_text):
	
	pass # Replace with function body.



func _on_Export_pressed():
	
	
	pass
