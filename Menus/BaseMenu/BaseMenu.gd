tool
extends Control

onready var YHAGlobal = get_node("..")

func _ready():
	while YHAGlobal.name != "YH Mod Assistant":
		YHAGlobal = YHAGlobal.get_node("..")
		if YHAGlobal is ViewportContainer:
			print("Cant find YH Mod Assistant")
			return false
	



