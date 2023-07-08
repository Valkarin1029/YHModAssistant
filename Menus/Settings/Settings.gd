tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"


func _ready():
	YHAGlobal.connect("loaded_settings", self, "_load_settings")
	
	for node in get_tree().get_nodes_in_group("setting"):
		if node.has_signal("pressed"):
			node.connect("pressed", self, "_save_settings", [null])
		if node.has_signal("text_changed"):
			node.connect("text_changed", self, "_save_settings")
	

func _load_settings():
	var _settings = YHAGlobal._settings
	for section in _settings:
		match section:
			"General":
				$"%ReopenLast".pressed = _settings[section]['ReopenLast']
#				print(_settings[section])
				$"%defualt_export_path".text = _settings[section]["defualt_export_path"]
				$"%RememberPreviousModName".pressed = _settings[section]["RememberPreviousModName"]
			"Character Template":
				$"%char_loader_Support".pressed = _settings[section]["char_loader_Support"]
			"Overwrites Template":
				$"%add_anim_folder_overwrites".pressed = _settings[section]["add_anim_folder_overwrites"]
			"Experimental":
				pass

func _save_settings(text):
	var _settings = YHAGlobal._settings
	for section in _settings:
		match section:
			"General":
				_settings[section]['ReopenLast'] = $"%ReopenLast".pressed
				_settings[section]["defualt_export_path"] = $"%defualt_export_path".text
				_settings[section]["RememberPreviousModName"] = $"%RememberPreviousModName".pressed
			"Character Template":
				_settings[section]["char_loader_Support"] = $"%char_loader_Support".pressed
			"Overwrites Template":
				_settings[section]["add_anim_folder_overwrites"] = $"%add_anim_folder_overwrites".pressed
			"Experimental":
				pass
	
	var file = File.new()
	
	if not file.open("res://addons/YHModAssistant/settings.json", File.WRITE) == OK:
		printerr("Unable to open settings config file - YH Mod Assistant")
		return
#	print("Creating Settings File For First Launch - YH Mod Assistant")
#	print(_settings)
	file.store_string(JSON.print(_settings, "\t"))
	file.close()
	



func _on_Back_pressed():
	YHAGlobal.change_scene("Home")


func _on_SelectExportFolderS_dir_selected(dir):
	$"%defualt_export_path".text = dir
	_save_settings(null)


func _on_SelectExportPath_pressed():
	$"%SelectExportFolderS".popup()
