tool
extends "res://addons/YHMA/Menus/BaseMenu/BaseMenu.gd"


func _ready():
	YHAGlobal.connect("loaded_settings", self, "_load_settings")
	
	for node in get_tree().get_nodes_in_group("setting"):
		if node.has_signal("pressed"):
			node.connect("pressed", self, "_save_settings")
		if node.has_signal("text_changed"):
			node.connect("text_changed", self, "_on_text_changed")
	

func _load_settings():
	var settings = YHAGlobal.settings
	for section in settings:
		match section:
			"General":
				$"%ReopenLast".pressed = settings[section]['ReopenLast']
				$"%defualt_export_path".text = settings[section]["defualt_export_path"]
				$"%RememberPreviousModName".pressed = settings[section]["RememberPreviousModName"]
			"Character Template":
				$"%char_loader_Support".pressed = settings[section]["char_loader_Support"]
			"Overwrites Template":
				$"%add_anim_folder_overwrites".pressed = settings[section]["add_anim_folder_overwrites"]
			"Experimental":
				pass

func _save_settings():
	var settings = YHAGlobal.settings
	for section in settings:
		match section:
			"General":
				settings[section]['ReopenLast'] = $"%ReopenLast".pressed
				settings[section]["defualt_export_path"] = $"%defualt_export_path".text
				settings[section]["RememberPreviousModName"] = $"%RememberPreviousModName".pressed
			"Character Template":
				settings[section]["char_loader_Support"] = $"%char_loader_Support".pressed
			"Overwrites Template":
				settings[section]["add_anim_folder_overwrites"] = $"%add_anim_folder_overwrites".pressed
			"Experimental":
				pass
	
	var file = File.new()
	
	if not file.open("res://addons/YHMA/settings.json", File.WRITE) == OK:
		printerr("[YHMA] Unable to open settings config file")
		return
#	print("[YHMA] Creating Settings File For First Launch")
#	print(settings)
	file.store_string(JSON.print(settings, "\t"))
	file.close()
	YHAGlobal.emit_signal("settings_updated")
	



func _on_Back_pressed():
	_save_settings()
	YHAGlobal.change_scene("Home")


func _on_SelectExportFolderS_dir_selected(dir):
	$"%defualt_export_path".text = dir
	_save_settings()


func _on_SelectExportPath_pressed():
	$"%SelectExportFolderS".popup()


func _on_text_changed(new_text):
	_save_settings()
	pass # Replace with function body.
