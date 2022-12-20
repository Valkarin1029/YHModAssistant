tool
extends Control

onready var main = get_parent()
onready var UI = $"../Loaded"

onready var Export = $"../Loaded/VBoxContainer/Export"


func _ready():
#	print(main)
	pass

func _on_UseMetaName_confirmed():
	var _name = ''
	
	var file = File.new()
	
	file.open(main.modfldrpth.plus_file("_metadata"), File.READ)
	
	var contents = JSON.parse(file.get_as_text()).result
	
	file.close()
	
	if contents.has('name'):
		_name = contents.get('name')
	else:
		push_error("Couldn't use metadata name because it doesn't exist")
		return
	
	$"%ModNameTB".text = _name
	main.mod_name = _name
	

func _on_UseMetaName_about_to_show():
	var _name = ''
	
	var file = File.new()
	
	file.open(main.modfldrpth.plus_file("_metadata"), File.READ)
	
	var contents = JSON.parse(file.get_as_text()).result
	
	file.close()
	
	if contents.has('name'):
		_name = contents.get('name')
	
	if _name == $"%ModNameTB".text:
#		print("yes")
		$"%UseMetaName".hide()


func _on_FileDialog_dir_selected(dir):
	main.modfldrpth = dir
	$"%Folderpth".text = dir
	var file = File.new()
	
	if file.file_exists(dir.plus_file('modmain.gd')) or file.file_exists(dir.plus_file('ModMain.gd')):
		pass
	else:
		push_error("This folder does not contain a modmain.gd! Is this the right directory? If so make a modmain.gd and try again.")
		return
	
	main.checkFormetaData(true)
	
	UI.emit_signal("modfldrPathUpdated")
	Export._update_auto_export()
	
	$"%Menu".visible = false
	$"%Loaded".visible = true
	
	pass # Replace with function body.


func _on_ExportFolderPath_about_to_show():
	$"%ExportFolderPath".current_dir = main.EXPORTPATH


func _on_ExportFolderPath_dir_selected(dir):
	main.EXPORTPATH = dir
	$"%ExportPath".text = dir
