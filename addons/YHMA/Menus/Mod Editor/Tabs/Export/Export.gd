tool
extends Tabs

onready var YHAGlobal = find_parent("YHMA")
#onready var DEFAULT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")
onready var DEFAULT_EXPORT_PATH = YHAGlobal.settings["General"]["defualt_export_path"]

var current_mod_path = null

var export_path = ""

var export_name = ""
var previous_export_name = ""

var mod_info

func _ready():
	var cfg = ConfigFile.new()
	YHAGlobal = find_parent("YHMA")
	if DEFAULT_EXPORT_PATH == "":
		DEFAULT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")
	if not YHAGlobal == null:
		current_mod_path = YHAGlobal.current_mod_path
		YHAGlobal.connect("load_mod_info", self, "_load_mod_info")
		YHAGlobal.connect("settings_updated", self, "_update_settings_changes")
	
	$"%Export Path".placeholder_text = DEFAULT_EXPORT_PATH
	
	cfg.load("res://addons/YHMA/SaveData.cfg")
	previous_export_name = cfg.get_value("Export", "PreviousExportName", previous_export_name)
	

func _update_settings_changes():
	DEFAULT_EXPORT_PATH = YHAGlobal.settings["General"]["defualt_export_path"]
	if DEFAULT_EXPORT_PATH == "":
		DEFAULT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")
	$"%Export Path".placeholder_text = DEFAULT_EXPORT_PATH

func _load_mod_info(replace):
	YHAGlobal = find_parent("YHMA")
	
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
#		print(mod_info)
	
		previous_export_name = mod_info.name
		$"%FileName".placeholder_text = mod_info.name

func _on_SelectExportPath_pressed():
	$"%SelectExportFolder".popup()

func _on_SelectExportFolder_dir_selected(dir):
	export_path = dir
	$"%Export Path".text = dir

func _on_Export_Path_text_changed(new_text):
	var dir = Directory.new()
	if not dir.dir_exists(new_text):
		$"%ExportPathError".visible = true
		$"%OpenExportPath".disabled = true
		$"%AutoExport".disabled = true
		$"%AutoExport".pressed = false
		$"%Export".disabled = true
		
	else:
		$"%ExportPathError".visible = false
		$"%OpenExportPath".disabled = false
		$"%AutoExport".disabled = false
		$"%Export".disabled = false
	
		export_path = new_text

func _on_FileName_text_changed(new_text):
	export_name = new_text
	pass # Replace with function body.

func _on_OpenExportPath_pressed():
	OS.shell_open(DEFAULT_EXPORT_PATH if export_path == "" else export_path)

func _on_Export_pressed():
	var zip = ZipMod.new()
	var dir = Directory.new()
	var cfg = ConfigFile.new()
	
	var _export_path = DEFAULT_EXPORT_PATH if export_path == "" else export_path
	var _export_name = mod_info.name if export_name == "" else export_name
	
	if not dir.dir_exists(current_mod_path):
		printerr("[YHMA] The mod folder does not exist. Either the mod folder name changed or was removed")
		return false
	
	if not dir.dir_exists(_export_path):
		printerr("[YHMA] Export Directory Does Not Exist")
		return false
	
	if $"%IncludeVersion".pressed:
		_export_name = _export_name + "_v" + mod_info.version
	
	if dir.file_exists(_export_path.plus_file(previous_export_name+".zip")):
		dir.remove(_export_path.plus_file(previous_export_name+".zip"))
	
	previous_export_name = _export_name
	
	cfg.load("res://addons/YHMA/SaveData.cfg")
	if YHAGlobal.settings["General"]["RememberPreviousModName"]:
		cfg.set_value("Export", "PreviousExportName", previous_export_name)
	else:
		cfg.set_value("Export", "PreviousExportName", null)
	cfg.save("res://addons/YHMA/SaveData.cfg")
	
	
	var succes = zip.zipDirectory(ProjectSettings.globalize_path(current_mod_path), 
			_export_path.plus_file(_export_name+".zip"), true)
	
	if $"%IncludeImport".pressed:
		succes = zip.zipDirectory(ProjectSettings.globalize_path("res://.import"), 
			_export_path.plus_file(_export_name+".zip"), false)
	
	return succes
	
	pass





func _on_Button_pressed():
	var z = ZipMod.new()
	
	z.test(ProjectSettings.globalize_path(current_mod_path))
	pass

