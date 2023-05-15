tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

export(ButtonGroup) var templateButtonGroup

onready var animPlayer = $AnimationPlayer

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
	print(pressed)
