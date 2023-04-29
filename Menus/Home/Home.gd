tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

signal LoadMod()

func _ready():
	
	var plugin_config = ConfigFile.new()
	
	if plugin_config.load("res://addons/YHModAssistant/plugin.cfg") != OK:
		printerr("Could not read config file -YH Mod Assistant")
	
	$"%AssistantVersionLabel".bbcode_text = $"%AssistantVersionLabel".bbcode_text.format(
		{"version": plugin_config.get_value("plugin", "version")}
		)
	
	
	

func _on_Create_Mod_pressed():
	pass

func _on_Select_Mod_pressed():
	$"%SelectFolder".popup()

func _on_SelectFolder_dir_selected(dir):
	if not is_valid_mod(dir):
		printerr("This is not a mod folder or missing modmain.gd -YH Assistant")
		return
	
	YHAGlobal.current_mod_path = dir
	
	YHAGlobal.change_scene("Mod Editor")
	YHAGlobal.emit_signal("load_mod_info", true)
#	YHAGlobal.change_scene("res://addons/YHModAssistant/Menus/Mod Editor/Mod Editor.tscn")
	


