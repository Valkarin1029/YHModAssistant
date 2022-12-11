tool
extends Control


var mod_name = ''

var modfldrpth = ''

var EXPORTPATH = OS.get_executable_path().get_base_dir().plus_file("mods")

func _init():
	var folderpath = ProjectSettings.globalize_path("res://addons/YHModAssistant")
	var output = []
	print(folderpath)
#	OS.execute("CMD.exe", ["/C", 'cd "{path}" && git fetch'.format({"path":folderpath})], true, output, false, true)
	OS.execute("git.exe", ['cd "{path}" && dir'], true, output, false, true)

	print(output)
	pass
	

func _ready():
#	var folderpath = ProjectSettings.globalize_path("res://addons/YHModAssistant")
#	var output = []
#
#	OS.execute("cmd.exe", ["/c", 'cd "{path}" && git fetch'.format({"path":folderpath})], true, output)
#
#	print(output)
	
	EXPORTPATH = OS.get_executable_path().get_base_dir().plus_file("mods")
#	print(EXPORTPATH)
	$"%ExportPath".placeholder_text = EXPORTPATH


func _on_FolderBrowseButton_pressed():
	$"%ModFolderPath".popup()


func _on_FileDialog_dir_selected(dir):
	modfldrpth = dir
	$"%Folderpth".text = dir
	var file = File.new()
	
	checkFormetaData()
	
	_update_auto_export()
	pass # Replace with function body.


func exportZip():
	var dir = Directory.new()
	var file = File.new()
	modfldrpth = ProjectSettings.globalize_path(modfldrpth)
	var _mod_name = mod_name
	
	print("Exporting {mod_name} to {export}".format({"mod_name": mod_name, "export": EXPORTPATH}))
	
	file.open(modfldrpth.plus_file("_metadata"), File.READ)
	var metaContents = JSON.parse(file.get_as_text()).result
	file.close()
	
	if $"%VersionNumIncludedName".pressed:
		_mod_name = mod_name +"_v"+ metaContents.get('version')
		
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
		
	if mod_name == '':
		push_error("Please input a name for the mod")
		return false
	if modfldrpth == '':
		push_error("You need to set your folder path")
		return false
	
	if file.file_exists(EXPORTPATH.plus_file(mod_name+".zip")):
		dir.remove(EXPORTPATH.plus_file(mod_name+".zip"))
	
	var outputs = []
	var zippth = "res://addons/YHModAssistant/"
	zippth = ProjectSettings.globalize_path(zippth)
	
	OS.execute("cmd.exe", ["/c", 'py --version'], true, outputs)
	
	if not outputs[0].to_lower().match("python*"):
		printerr("Python is not installed")
	
	
	OS.execute("cmd.exe", ["/C",'cd "{pth}" && py .\\zipper.py'.format({"pth":zippth})], true, outputs)
	
	if file.file_exists(EXPORTPATH.plus_file(_mod_name+".zip")):
		print("Export Sucessful")
		return true
	else:
		push_error("Export Failed! \nThis could be caused because the mods folder does not exist in your godot.exe folder location")
		
	dir.remove("res://addons/YHModAssistant/cfg.txt")
	
	return false
	
func _on_ModNameTB_text_changed(new_text):
	mod_name = new_text
	_update_auto_export()

func _on_Export_pressed():
	exportZip()

func _on_Folderpth_text_changed(new_text):
	modfldrpth = new_text
	_update_auto_export()

func checkFormetaData():
	var file = File.new()
	if not file.file_exists(modfldrpth.plus_file("_metadata")):
		$"%CreatemetaDataBtn".visible = true
		$"%EditmetaDataBtn".visible = false
	else:
		$"%CreatemetaDataBtn".visible = false
		$"%EditmetaDataBtn".visible = true
		
		var _name = ''
		
		file.open(modfldrpth.plus_file("_metadata"), File.READ)
		var contents = JSON.parse(file.get_as_text()).result
		file.close()
		if contents.has('name'):
			_name = contents.get('name')
		if _name == $"%ModNameTB".text:
			print("Name matches meta_data")
		else:
			$"%UseMetaName".popup()


func _on_UseMetaName_about_to_show():
	var _name = ''
	
	var file = File.new()
	
	file.open(modfldrpth.plus_file("_metadata"), File.READ)
	
	var contents = JSON.parse(file.get_as_text()).result
	
	file.close()
	
	if contents.has('name'):
		_name = contents.get('name')
	
	if _name == $"%ModNameTB".text:
#		print("yes")
		$"%UseMetaName".hide()

func _on_UseMetaName_confirmed():
	var _name = ''
	
	var file = File.new()
	
	file.open(modfldrpth.plus_file("_metadata"), File.READ)
	
	var contents = JSON.parse(file.get_as_text()).result
	
	file.close()
	
	if contents.has('name'):
		_name = contents.get('name')
	else:
		push_error("Couldn't use metadata name because it doesn't exist")
		return
	
	$"%ModNameTB".text = _name
	mod_name = _name


func _update_auto_export():
	
	if $"%AutoExport".pressed:
		_create_cfg()
	
	pass

func _create_cfg(mod_name = mod_name):
	
	modfldrpth = ProjectSettings.globalize_path(modfldrpth)
	
#	print(mod_name)
#	print(modfldrpth)
#	print(EXPORTPATH)
	
	var file = File.new()
	file.open("res://addons/YHModAssistant/cfg.txt", file.WRITE)
	file.store_string("{name},{dir},{savepth}".format({
		"name":mod_name,
		"dir":modfldrpth,
		"savepth":EXPORTPATH,
		}))
	file.close()


func _on_FeedBack_meta_clicked(meta):
	meta = meta.replace('<','')
	meta = meta.replace('>','')
	if meta.begins_with("https://forms.gle"):
		OS.shell_open(meta)


func _on_MakeCFG_pressed():
	_create_cfg()


func _on_ExportFolderPath_about_to_show():
	$"%ExportFolderPath".current_dir = EXPORTPATH


func _on_ExportFolderPath_dir_selected(dir):
	EXPORTPATH = dir
	$"%ExportPath".text = dir


func _on_ExportPath_text_changed(new_text):
	EXPORTPATH = new_text


func _on_ExportBrowse_pressed():
	$"%ExportFolderPath".popup()


func _on_OpenExportFolder_pressed():
	OS.shell_open(EXPORTPATH)


func _on_ClearExportFolderBtn_pressed():
	$"%ClearExportFolder".popup()
