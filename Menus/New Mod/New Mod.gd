tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

export(ButtonGroup) var templateButtonGroup

func slideAnime(object, open, distance):
	var tween = $Tween
	if open:
		object.visible = true
		tween.interpolate_property(object, "rect_min_size", 
		object.rect_min_size, Vector2(0,distance), 
		.5, Tween.TRANS_QUART)
		tween.start()
	else:
		tween.interpolate_property(object, "rect_min_size",
		 object.rect_min_size, Vector2.ZERO,
		 .5, Tween.TRANS_QUART)
		tween.start()

func _empty_inputs():
	#Character Options
	$"%CharName".text = ""
	$"%CharButtonName".text = ""
	
	#Overwrites Options
	$"%Ninja".pressed = false
	$"%Wizard".pressed = false
	$"%Cowboy".pressed = false
	$"%Robot".pressed = false
	
	#Mod Info
	$VBoxContainer/ModInfo/ScrollContainer.scroll_vertical = 0
	$"%FriendlyName".text = ""
	$"%Name".text = ""
	$"%Description".text = ""
	$"%Version".text = ""
	$"%Author".text = ""
	$"%Required".text = ""
	$"%Priority".value = 0
	$"%Client Side".pressed = false
	$"%Overwrites".pressed = false

func _on_BlankTemp_toggled(button_pressed):
#	print($"%BlankTemp".group.get_buttons())
	pass

func _on_CharTemp_toggled(button_pressed):
	slideAnime($"%CharOptions", button_pressed, 115)
	if button_pressed:
		$"%Required".text = "char_loader, "
	else:
		$"%Required".text = ""

func _on_OverwritesTemp_toggled(button_pressed):
	slideAnime($"%OWOptions", button_pressed, 145)
	$"%Client Side".pressed = button_pressed
	$"%Overwrites".pressed = button_pressed
	
	if button_pressed:
		pass
	else:
		pass
	

func _on_TemplatesNext_pressed():
	$"%Templates".visible = false
	$"%ModInfo".visible = true

func _on_TemplatesHome_pressed():
	YHAGlobal.change_scene("Home")
	_empty_inputs()

func _on_ModInfoBack_pressed():
	$"%Templates".visible = true
	$"%ModInfo".visible = false


func _on_Name_text_changed(new_text):
	var dir = Directory.new()
	if dir.dir_exists("res://%s" % new_text) and new_text != "":
		$"%Create".disabled = true
		$"%ModExistsError".visible = true
	else:
		$"%Create".disabled = false
		$"%ModExistsError".visible = false
	

func _on_Create_pressed():
	var pressed = templateButtonGroup.get_pressed_button()
#	print(pressed)
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	cfg.load("res://addons/YHModAssistant/Menus/New Mod/templates.cfg")
	
	var mod_dir = "res://%s" % $"%Name".text
	
	if not dir.make_dir(mod_dir) == OK:
		printerr("Failed to make mod folder - YH Assistant")
		return
	
	var formats = {
		"mod_name": $"%Name".text,
		"character_name": $"%CharName".text,
		"character_path": "res://%s/characters/%s/%s" % [$"%Name".text, $"%CharName".text, $"%CharName".text+".tscn"],
		"character_button": "" if $"%CharButtonName".text == "" else ", \""+$"%CharButtonName".text+"\"",
	}
	
	for scripts in cfg.get_section_keys(pressed.name+".basefiles"):
		var contents = cfg.get_value(pressed.name+".basefiles",scripts)
		contents = contents.format(formats)
		file.open(mod_dir.plus_file(scripts), File.WRITE)
		file.store_string(contents)
		file.close()
	
	if pressed.name == "CharTemp":
		_create_character_mod()
	
	EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
#	print(cfg.get_value(pressed.name+".basefiles","modmain.gd"))
	

func _create_character_mod():
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	cfg.load("res://addons/YHModAssistant/Menus/New Mod/templates.cfg")
	
	var mod_dir = "res://%s" % $"%Name".text
	
	if not dir.make_dir_recursive(mod_dir+"/characters/%s" % $"%CharName".text) == OK:
		printerr("Unable to make character template folder - YH Mod Assistant")
		return
	
	var baseChar = load("res://characters/BaseChar.tscn")
	var newChar = PackedScene.new()
	
#	newChar._bundled = baseChar._bundled
	
	newChar._bundled["names"] = [$"%CharName".text]
	newChar._bundled["variants"] = [baseChar]
	
#	newChar.pack()

#	newChar._bundled = { "names": [root_name], "variants": [inherits], "node_count": 1, "nodes": [-1, -1, 2147483647, 0, -1, 0, 0], "conn_count": 0, "conns": [], "node_paths": [], "editable_instances": [], "base_scene": 0, "version": 2 }
	
	ResourceSaver.save(mod_dir+"/characters/%s/%s" % [$"%CharName".text, $"%CharName".text+".tscn"],
	 newChar)
	
