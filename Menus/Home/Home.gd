tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"


func _on_Create_Mod_pressed():
	pass

func _on_Select_Mod_pressed():
	$"%SelectFolder".popup()

func _on_SelectFolder_dir_selected(dir):
	if not is_valid_mod(dir):
		printerr("This is not a mod folder or missing modmain.gd")
		return
	

func is_valid_mod(dir):
	var d = Directory.new()
	d.open(dir)
	
	if not d.list_dir_begin(true) == OK:
		printerr("Folder Empty")
		return
	
	while true:
		var file = d.get_next()
		
		file = file.to_lower()
		
		if file == "":
			return false
		
		if file == "modmain.gd":
			return true
		
	
