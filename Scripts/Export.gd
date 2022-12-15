tool
extends VBoxContainer

onready var main = $"../../.."

func _ready():
	
#	print(main)
	
	pass

func _on_ExportPath_text_changed(new_text):
	main.EXPORTPATH = new_text

func _on_ExportBrowse_pressed():
	$"%ExportFolderPath".popup()

func _on_Export_pressed():
	exportZip()

func exportZip():
	var dir = Directory.new()
	var file = File.new()
	var modfldrpth = ProjectSettings.globalize_path(main.modfldrpth)
	var _mod_name = main.mod_name
	
	var EXPORTPATH = main.EXPORTPATH
	
	print("Exporting {mod_name} to {export}".format({"mod_name": _mod_name, "export": EXPORTPATH}))
	
	var er = file.open(modfldrpth.plus_file("_metadata"), File.READ)
	
	var metaContents
	if er == OK:
		metaContents= JSON.parse(file.get_as_text()).result
		file.close()
	else:
		push_warning("No _metadata cannot get metadata version")
	
	if $"%VersionNumIncludedName".pressed:
		_mod_name = _mod_name +"_v"+ metaContents.get('version')
		
	if not dir.dir_exists(modfldrpth):
		push_error("The mod folder does not exist. Did you put the correct path?")
		return
	if not dir.dir_exists(EXPORTPATH):
		push_error("The export location does not exist. Did you put the correct path? [Current Path: %s]" % EXPORTPATH)
		return
	
	_create_cfg(_mod_name)
	
	#Checks to see if it exist so it can remove it
	if file.file_exists(EXPORTPATH.plus_file(_mod_name+".zip")):
		dir.remove(EXPORTPATH.plus_file(_mod_name+".zip"))
		
	if _mod_name == '':
		push_error("Please input a name for the mod")
		return false
	if modfldrpth == '':
		push_error("You need to set your folder path")
		return false
	
	if file.file_exists(EXPORTPATH.plus_file(_mod_name+".zip")):
		dir.remove(EXPORTPATH.plus_file(_mod_name+".zip"))
	
	var outputs = []
	var zippth = "res://addons/YHModAssistant/"
	zippth = ProjectSettings.globalize_path(zippth)
	
	OS.execute("cmd.exe", ["/c", 'py --version'], true, outputs)
	if not outputs[0].to_lower().match("python*"):
		printerr("Python is not installed")
	
	OS.execute("cmd.exe", ["/C",'cd "{pth}" && py .\\zipper.py'.format({"pth":zippth})], true, outputs)
	if file.file_exists(EXPORTPATH.plus_file(_mod_name+".zip")):
		print("Export Sucessful")
		dir.remove("res://addons/YHModAssistant/cfg.txt")
		return true
	else:
		push_error("Export Failed! \nThis could be caused because the mods folder does not exist in your godot.exe folder location")
		dir.remove("res://addons/YHModAssistant/cfg.txt")
		return false
	

func _create_cfg(mod_name = main.mod_name):
	
	var modfldrpth = ProjectSettings.globalize_path(main.modfldrpth)
	
	
	var file = File.new()
	file.open("res://addons/YHModAssistant/cfg.txt", file.WRITE)
	file.store_string("{name},{dir},{savepth}".format({
		"name":mod_name,
		"dir":modfldrpth,
		"savepth":main.EXPORTPATH,
		}))
	file.close()
	

func _update_auto_export():
	
	if $"%AutoExport".pressed:
		_create_cfg()
	
	pass
