tool
extends "res://addons/YHMA/Menus/BaseMenu/BaseMenu.gd"

func _ready():
	YHMAGlobal.connect("loaded_settings", self, "_load_settings")
	
	for node in get_tree().get_nodes_in_group("setting"):
		if node.has_signal("pressed"):
			node.connect("pressed", self, "_save_settings")
		if node.has_signal("text_changed"):
			node.connect("text_changed", self, "_on_text_changed")
	


func _load_settings():
	var settings = YHMAGlobal.settings
	for section in settings:
		match section:
			"General":
				$"%ReopenLast".pressed = settings[section]['ReopenLast']
				$"%NotifyOfUpdate".pressed = settings[section]['NotifyOfUpdate']
				$"%NotifyOfPreRelease".pressed = settings[section]['NotifyOfPreRelease']
				$"%defualt_export_path".text = settings[section]["defualt_export_path"]
				$"%RememberPreviousModName".pressed = settings[section]["RememberPreviousModName"]
			"Developer":
				$"%Debug".pressed = settings[section]["Debug"]
			"Overwrites Template":
				$"%add_anim_folder_overwrites".pressed = settings[section]["add_anim_folder_overwrites"]
			"Experimental":
				pass

func _save_settings():
	var settings = YHMAGlobal.settings
	for section in settings:
		match section:
			"General":
				settings[section]['ReopenLast'] = $"%ReopenLast".pressed
				settings[section]['NotifyOfUpdate'] = $"%NotifyOfUpdate".pressed
				settings[section]['NotifyOfPreRelease'] = $"%NotifyOfPreRelease".pressed
				settings[section]["defualt_export_path"] = $"%defualt_export_path".text
				settings[section]["RememberPreviousModName"] = $"%RememberPreviousModName".pressed
			"Developer":
				settings[section]["Debug"] = $"%Debug".pressed
			"Overwrites Template":
				settings[section]["add_anim_folder_overwrites"] = $"%add_anim_folder_overwrites".pressed
			"Experimental":
				pass
	
	var file = File.new()
	
	if not file.open(YHMAGlobal.tempDirPath+"/settings.json", File.WRITE) == OK:
		printerr("[YHMA] Unable to open settings config file")
		return
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	YHMAGlobal.emit_signal("settings_updated")
	

func _on_Back_pressed():
	_save_settings()
	YHMAGlobal.change_scene("Home")


func _on_SelectExportFolderS_dir_selected(dir):
	$"%defualt_export_path".text = dir
	_save_settings()


func _on_SelectExportPath_pressed():
	$"%SelectExportFolderS".popup()


func _on_text_changed(new_text):
	_save_settings()
	pass # Replace with function body.


func _on_resetSettings_pressed():
	var dir = Directory.new()
	if dir.file_exists(YHMAGlobal.tempDirPath+"/settings.json"):
		dir.remove(YHMAGlobal.tempDirPath+"/settings.json")
	YHMAGlobal._create_settings_config()
	YHMAGlobal._get_settings()
	pass # Replace with function body.


func _on_resetSavedData_pressed():
	var dir = Directory.new()
	if dir.file_exists(YHMAGlobal.tempDirPath+"/SaveData.cfg"):
		dir.remove(YHMAGlobal.tempDirPath+"/SaveData.cfg")
