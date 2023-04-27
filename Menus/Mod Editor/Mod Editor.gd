tool
extends "res://addons/YHModAssistant/Menus/BaseMenu/BaseMenu.gd"

var current_mod_path = null

# Called when the node enters the scene tree for the first time.
func _ready():
	current_mod_path = YHAGlobal.current_mod_path
	find_node("ApplyMeta").connect("pressed", self, "_apply_metadata")

func _apply_metadata():
	current_mod_path = YHAGlobal.current_mod_path
	
	print(current_mod_path)
	
	if not is_valid_mod(current_mod_path):
		printerr("Can't apply metadata. Current mod path is not valid")
		return
	
	


func _on_Back_pressed():
	YHAGlobal.change_scene("Home")
