tool
extends Tabs

onready var YHAGlobal = find_parent("YH Mod Assistant")

var current_mod_path = null

onready var DEFUALT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")
var export_path = ""

func _ready():
	YHAGlobal = find_parent("YH Mod Assistant")
	if not YHAGlobal == null:
		current_mod_path = YHAGlobal.current_mod_path
		YHAGlobal.connect("load_mod_info", self, "_load_mod_path")
	
	$"%Export Path".placeholder_text = DEFUALT_EXPORT_PATH

func _load_mod_path():
	YHAGlobal = find_parent("YH Mod Assistant")
	current_mod_path = YHAGlobal.current_mod_path
	$"%ModFolderPath".text = current_mod_path


func _on_SelectExportPath_pressed():
	$"%SelectExportFolder".popup()


func _on_SelectExportFolder_dir_selected(dir):
	export_path = dir
	$"%Export Path".text = dir


func _on_Export_Path_text_changed(new_text):
	export_path = new_text
