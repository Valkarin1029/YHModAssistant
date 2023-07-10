tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

#export(ButtonGroup) var templateButtonGroup
export(ButtonGroup) var templateButtonGroup 


func _enter_tree():
	templateButtonGroup = $"%BlankTemp".group
#	print(templateButtonGroup)


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
	$"%IncludeBasicFolders".pressed = false
	
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
	
	$"%BlankTemp".pressed = true

func _on_CharName_text_changed(new_text):
	if new_text == "":
		$"%CharNameLabel".bbcode_text = "[color=red]Character Name[/color]"
		$"%TemplatesNext".disabled = true
	else:
		$"%TemplatesNext".disabled = false
		$"%CharNameLabel".bbcode_text = "Character Name"

func _on_BlankTemp_toggled(button_pressed):
#	print($"%BlankTemp".group.get_buttons())
	pass

func _on_CharTemp_toggled(button_pressed):
	slideAnime($"%CharOptions", button_pressed, 145)
	if button_pressed:
		if YHAGlobal.settings["Character Template"]["char_loader_Support"]:
			$"%Required".text = "char_loader"
		if $"%CharName".text == "":
			$"%CharNameLabel".bbcode_text = "[color=red]Character Name[/color]"
			$"%TemplatesNext".disabled = true
	else:
		$"%Required".text = ""
		$"%TemplatesNext".disabled = false
		$"%CharNameLabel".bbcode_text = "Character Name"

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
	
	if $"%Name".text == "" or $"%FriendlyName".text == "":
		$"%Create".disabled = true
		$"%InputModName".visible = true
	else:
		$"%Create".disabled = false
		$"%InputModName".visible = false

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
	elif new_text == "" or $"%FriendlyName".text == "":
		$"%Create".disabled = true
		$"%ModExistsError".visible = false
		$"%InputModName".visible = true
	else:
		$"%Create".disabled = false
		$"%ModExistsError".visible = false
		$"%InputModName".visible = false
	
	
func _on_FriendlyName_text_changed(new_text):
	if new_text == "" or $"%Name".text == "":
		$"%Create".disabled = true
		$"%InputModName".visible = true
	else:
		$"%Create".disabled = false
		$"%InputModName".visible = false

func _on_Create_pressed():
	var pressed = templateButtonGroup.get_pressed_button()
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	var save_data_cfg = ConfigFile.new()
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
	
	if cfg.has_section(pressed.name+".char_loader"):
		for scripts in cfg.get_section_keys(pressed.name+".char_loader"):
			var contents = cfg.get_value(pressed.name+".char_loader",scripts)
			contents = contents.format(formats)
			file.open(mod_dir.plus_file(scripts), File.WRITE)
			file.store_string(contents)
			file.close()
	
	if pressed.name == "CharTemp":
		_create_character_mod()
	elif pressed.name == "OverwritesTemp":
		_create_overwrites_mod()
	
	_gen_metadata(mod_dir)
	
	EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()
	
	
	print("Mod successfully created. Happy modding! - YH Mod Assistant")
	YHAGlobal.current_mod_path = mod_dir
	save_data_cfg.load("res://addons/YHModAssistant/SaveData.cfg")
	save_data_cfg.set_value("Export", "LastOpenedDir", mod_dir)
	save_data_cfg.save("res://addons/YHModAssistant/SaveData.cfg")
	YHAGlobal.get_node("Home/VBoxContainer/Continue_mod").visible = true
#	print(YHAGlobal.get_node("Home/VBoxContainer/Continue_mod"))
	
	YHAGlobal.change_scene("Mod Editor")
	_empty_inputs()
	YHAGlobal.emit_signal("load_mod_info", true)

func _gen_metadata(mod_dir):
	YHAGlobal = find_parent("YH Mod Assistant")
	
	var meta_data_path = mod_dir.plus_file("_metadata")
	
	var dir = Directory.new()
	var file = File.new()
	
	var required_mods = [""]
	
	for required in $"%Required".text.split(",", false):
		
		required = required.strip_edges()
		
		if required == "":
			continue
		
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
	

func _create_character_mod():
	var dir = Directory.new()
	var file = File.new()
	var cfg = ConfigFile.new()
	cfg.load("res://addons/YHModAssistant/Menus/New Mod/templates.cfg")
	
	var mod_dir = "res://%s" % $"%Name".text
	var character_folder = mod_dir+"/characters/%s" % $"%CharName".text
	
	if not dir.make_dir_recursive(character_folder) == OK:
		printerr("Unable to make character template folder - YH Mod Assistant")
		return
	
	var include_directories = ['/sprites', '/states', '/sounds', '/projectiles', '/ActionUiData']
	
	if $"%IncludeBasicFolders".pressed:
		for directory in include_directories:
			if dir.make_dir(character_folder+directory) != OK:
				push_error("Failed to make sub directories for the character")
				return false
	
	file.open(character_folder.plus_file($"%CharName".text+".gd"), File.WRITE)
	file.store_string(cfg.get_value("CharTemp.characterfiles", "character.gd"))
	file.close()
	
	_create_character_scenes(character_folder)
	

func _create_character_scenes(character_folder):
	
	var basePlayerInfo = load("res://characters/PlayerInfo.tscn").instance(3)
	var basePlayerExtra = load("res://ui/ActionSelector/PlayerExtra.tscn").instance(3)
	var baseChar = load("res://characters/BaseChar.tscn").instance(3)
	
	var newPlayerInfo = PackedScene.new()
	var newPlayerExtra = PackedScene.new()
	var newChar = PackedScene.new()
	
	newPlayerInfo.pack(basePlayerInfo)
	newPlayerExtra.pack(basePlayerExtra)
	
	ResourceSaver.save(character_folder.plus_file($"%CharName".text+"PlayerInfo"+".tscn"), newPlayerInfo)
	ResourceSaver.save(character_folder.plus_file($"%CharName".text+"PlayerExtra"+".tscn"), newPlayerExtra)
	
	baseChar.name = $"%CharName".text
	baseChar.set_script(load(character_folder.plus_file($"%CharName".text+".gd")))
	baseChar.player_info_scene = load(character_folder.plus_file($"%CharName".text+"PlayerInfo"+".tscn"))
	baseChar.player_extra_params_scene = load(character_folder.plus_file($"%CharName".text+"PlayerExtra"+".tscn"))
	
	newChar.pack(baseChar)
	
	ResourceSaver.save(character_folder.plus_file($"%CharName".text+".tscn"), newChar)
	baseChar.queue_free()
	basePlayerInfo.queue_free()
	basePlayerExtra.queue_free()
	

func _create_overwrites_mod():
	var dir = Directory.new()
	var file = File.new()
	
	var name_paths = {
	"Ninja":"res://characters/stickman/NinjaGuy.tscn", 
	"Cowboy":"res://characters/swordandgun/SwordGuy.tscn", 
	"Wizard":"res://characters/wizard/Wizard.tscn", 
	"Robot":"res://characters/robo/Robot.tscn", 
	}
	
	var mod_dir = "res://%s" % $"%Name".text
	
	var OverwritesFolder = mod_dir+'/Overwrites'
	
	if dir.make_dir(OverwritesFolder) != OK:
		push_error("Failed to make Overwrites folder")
		return false
	
	var selected = []
	
	if $"%Ninja".pressed:
		selected.append("Ninja")
	if $"%Wizard".pressed:
		selected.append("Wizard")
	if $"%Cowboy".pressed:
		selected.append("Cowboy")
	if $"%Robot".pressed:
		selected.append("Robot")
	
#	print(selected)
	
	for chars in selected:
		dir.make_dir_recursive(OverwritesFolder+'/'+chars)
		if not YHAGlobal.settings["Overwrite Template"]["add_anim_folder_overwrites"]:
			continue
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/Sounds/BaseSounds')
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/Sounds/StateSounds')
		
		if file.file_exists(name_paths.get(chars)):
			var instCharTS = load(name_paths.get(chars)).instance()
			var instCharAnim = instCharTS.get_node("Flip/Sprite")
			var instCharFrames = instCharAnim.get_sprite_frames()
			for animation in instCharFrames.get_animation_names():
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/'+animation)
			
			if chars == "Cowboy":
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/ShootingArm/default')
			elif chars == "Wizard":
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/LiftoffAir/default')
			elif chars == "Robot":
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/ChainsawArm/default')
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/DriveJumpSprite/default')
			
			instCharTS.free()
		else:
			continue
	






