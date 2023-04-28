tool
extends Tabs

onready var YHAGlobal = find_parent("YH Mod Assistant")
onready var DEFAULT_EXPORT_PATH = OS.get_executable_path().get_base_dir().plus_file("mods")

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
	
	$"%Export Path".placeholder_text = DEFAULT_EXPORT_PATH
	
	
	

func _load_mod_info(replace):
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
		
	
	previous_export_name = mod_info.name
	$"%FileName".placeholder_text = mod_info.name

func _on_SelectExportPath_pressed():
	$"%SelectExportFolder".popup()

func _on_SelectExportFolder_dir_selected(dir):
	export_path = dir
	$"%Export Path".text = dir

func _on_Export_Path_text_changed(new_text):
	export_path = new_text

func _on_FileName_text_changed(new_text):
	export_name = new_text
	pass # Replace with function body.

func _on_OpenExportPath_pressed():
	OS.shell_open(DEFAULT_EXPORT_PATH if export_path == "" else export_path)

func _on_Export_pressed():
	var dir = Directory.new()
	var file = Directory.new()
	
	var _export_path = DEFAULT_EXPORT_PATH if export_path == "" else export_path
	var _export_name = mod_info.name if export_name == "" else export_name
	
	if not dir.dir_exists(current_mod_path):
		printerr("The mod folder does not exist. Either the mod folder name changed or was removed - YH Mod Assistant")
		return false
	
	if not dir.dir_exists(_export_path):
		printerr("Export Directory Does Not Exist -YH Mod Assistant")
		return false
	
	if $"%IncludeVersion".pressed:
		_export_name = _export_name + "_v" + mod_info.version
	
	if dir.file_exists(_export_path.plus_file(previous_export_name+".zip")):
		dir.remove(_export_path.plus_file(previous_export_name+".zip"))
	
	previous_export_name = _export_name
	
	var python_pth = ".\\addons\\YHModAssistant\\python-3.10.11-embed-amd64"
	
	var output = []
	OS.execute("CMD.exe", 
	["/C", 
	"cd {python_path} && python.exe ..\\zipper.py -fn {mod_name} -td {mod_folder_path} -ep {export_path}".format(
		{
			"python_path": python_pth,
			"mod_name": _export_name,
			"mod_folder_path": '"'+ProjectSettings.globalize_path(current_mod_path)+'"',
			"export_path": '"'+_export_path+'"'
		}
		)
	],
	true, 
	output)
#	printt("Output", output)
	
	if dir.file_exists(_export_path.plus_file(_export_name+'.zip')):
		print("Sucessfully Exported The Mod -YH Mod Assistant")
		return true
	else:
		printerr("Mod Failed to export -YH Mod Assistant")
		return false
	
	pass



