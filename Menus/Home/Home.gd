tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

signal LoadMod()

func _on_Create_Mod_pressed():
	pass

func _on_Select_Mod_pressed():
	$"%SelectFolder".popup()

func _on_SelectFolder_dir_selected(dir):
	if not is_valid_mod(dir):
		printerr("This is not a mod folder or missing modmain.gd")
		return
	
	YHAGlobal.current_mod_path = dir
	
	YHAGlobal.change_scene("Mod Editor")
	


