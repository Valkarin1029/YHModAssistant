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
	change_scene("ModInfo")

func _on_Character_pressed():
	mod_type = "character"
	change_scene("ModInfo")
	

func _on_Overwrites_pressed():
	mod_type = "overwrites"
	change_scene("ModInfo")
	$"%Client Side".pressed = true
	$"%Overwrites".pressed = true

func _reset_values():
	$"%FriendlyName".text = ""
	$"%Name".text = ""
	$"%Description".text = ""
	$"%Version".text = ""
	$"%Required".text = ""
	$"%Priority".value = 0
	$"%Client Side".pressed = false
	$"%Overwrites".pressed = false
	$ModInfo/VBoxContainer2/ScrollContainer.scroll_vertical = 0
	


func _on_Create_Mod_pressed():
	var dir = Directory.new()
	var file = File.new()
	
	if $"%Name".text == "" or $"%FriendlyName".text == "":
		printerr("Names Cannot be empty - YH Mod Assistant")
	
	if dir.dir_exists("res://%s" % $"%Name".text):
		printerr("A mod already exists in the filesystem with that name - YH Mod Assistant")
		return
	
	dir.make_dir("res://%s" % $"%Name".text)
	_create_metadata("res://%s" % $"%Name".text)
	_create_modmain("res://%s" % $"%Name".text)
	
	EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()

func _create_metadata(mod_path):
	
	var meta_data_path = mod_path.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	var required_mods = [""]
	
	for required in $"%Required".text.split(",", false):
		
		required = required.strip_edges()
		
		if required_mods[0] == "":
			required_mods.pop_front()
			required_mods.append(required)
			continue
		
		required_mods.append(required)
	
	var new_meta = {
		"friendly_name": $"%FriendlyName".text,
		"name": $"%Name".text,
		"description": $"%Description".text,
		"version": $"%Version".text,
		"author": $"%Author".text,
		"client_side": $"%Client Side".pressed,
		"overwrites": $"%Overwrites".pressed,
		"requires": required_mods,
		"priority": $"%Priority".value,
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
	
	var contents = cfg.get_value(mod_type, "modmain").format({"mod_name":$"%Name".text})
	
	file.open(mod_path.plus_file("modmain.gd"), File.WRITE)
	file.store_string(contents)
	file.close()
	
