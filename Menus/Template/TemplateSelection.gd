tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

var mod_type = "blank"

func change_scene(scene):
	if scene == null:
		printerr("Scene could not be loaded -YH Assistant")
		return
	
	for node in get_children():
		if node.name == scene:
			node.visible = true
		else:
			node.visible = false

func _on_Home_pressed():
	YHAGlobal.change_scene("Home")

func _on_Back_pressed():
	change_scene("SelectTemplates")
	_reset_values()

func _on_Blank_pressed():
	mod_type = "blank"
	_show_options_for_type()
	change_scene("ModInfo")

func _on_Character_pressed():
	mod_type = "character"
	_show_options_for_type()
	change_scene("ModInfo")
	

func _on_Overwrites_pressed():
	mod_type = "overwrites"
	_show_options_for_type()
	change_scene("ModInfo")
	

func _show_options_for_type():
	match mod_type:
		"blank":
			$"%BlankOptions".visible = true
			$"%CharacterOptions".visible = false
			$"%OverwritesOptions".visible = false
			
		"character":
			$"%BlankOptions".visible = false
			$"%CharacterOptions".visible = true
			$"%OverwritesOptions".visible = false
		
		"overwrites":
			$"%BlankOptions".visible = false
			$"%CharacterOptions".visible = false
			$"%OverwritesOptions".visible = true



func _reset_values():
	$"%ModName".text = ""
	


func _on_Create_Mod_pressed():
	var dir = Directory.new()
	var file = File.new()
	
	if $"%ModName".text == "":
		printerr("Names Cannot be empty - YH Mod Assistant")
	
	if dir.dir_exists("res://%s" % $"%ModName".text):
		printerr("A mod already exists in the filesystem with that name - YH Mod Assistant")
		return
	
	dir.make_dir("res://%s" % $"%ModName".text)
	_create_metadata("res://%s" % $"%ModName".text)
	_create_modmain("res://%s" % $"%ModName".text)
	
	YHAGlobal.change_scene("Mod Editor")
	YHAGlobal.current_mod_path = "res://%s" % $"%ModName".text
	YHAGlobal.emit_signal("load_mod_info", true)
	
	_reset_values()
	change_scene("SelectTemplates")
	
	EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()

func _create_metadata(mod_path):
	
	var meta_data_path = mod_path.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	
	var new_meta = {
		"friendly_name": "",
		"name": $"%ModName".text,
		"description": "",
		"version": "",
		"author": "",
		"client_side": true if mod_type == "overwrites" else false,
		"overwrites": true if mod_type == "overwrites" else false,
		"requires": [""],
		"priority": 0,
		"id": 12345,
		"link": "",
	}
	
	file.open(meta_data_path, File.WRITE)
	file.store_string(JSON.print(new_meta, "\t"))
	file.close()
	


func _create_modmain(mod_path):
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	
	cfg.load("res://addons/YHModAssistant/Menus/Template/templates.cfg")
	
	var contents = cfg.get_value(mod_type, "modmain").format({
		"mod_name":$"%ModName".text,
		})
	
	file.open(mod_path.plus_file("modmain.gd"), File.WRITE)
	file.store_string(contents)
	file.close()
	
	
