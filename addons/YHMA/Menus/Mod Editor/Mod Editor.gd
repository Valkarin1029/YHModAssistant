tool
extends "res://addons/YHMA/Menus/BaseMenu/BaseMenu.gd"

var current_mod_path = null


func _on_Back_pressed():
	find_node("AutoExport").pressed = false
	YHMAGlobal.change_scene("Home")
	

