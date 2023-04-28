tool
extends Tabs

onready var YHAGlobal = find_parent("YH Mod Assistant")

var current_mod_path = null


func _ready():
	YHAGlobal = find_parent("YH Mod Assistant")
	if not YHAGlobal == null:
		current_mod_path = YHAGlobal.current_mod_path
		YHAGlobal.connect("load_mod_info", self, "_load_mod_path")
	
func _load_mod_path():
	YHAGlobal = find_parent("YH Mod Assistant")
	current_mod_path = YHAGlobal.current_mod_path
	
