tool
extends MenuButton


onready var main = $"../../.."

var dir = Directory.new()
var file = File.new()

func _init():
	get_popup().connect("id_pressed", self, "_createTemplate")

func _on_MakeTemplate_about_to_show():
#	print("test")
	
	pass # Replace with function body.

func _createTemplate(id):
#	print(main.mod_name)
	if id == 0:
		if not _createDir(main.mod_name):
			return
		_createBlank(main.mod_name)
	elif id == 1:
		if not _createDir(main.mod_name):
			return
		pass
	elif id == 2:
		if not _createDir(main.mod_name):
			return
		pass
	
	

func _createDir(mod_name):
	
	if mod_name == '':
		push_error("Name cannot be blank. Please put a name in Mod Name")
		return false
	
	if dir.dir_exists("res://%s" % mod_name):
		push_error("Directory already exists! Delete the directory or change the name")
		return false
	
	if dir.make_dir("res://%s" % mod_name) == OK:
		var modpath = "res://%s" % mod_name
		
		if not _addBaseFiles(modpath):
			push_warning("Failed to add base files")
			return false
		else:
			main.modfldrpth = modpath
			$"%Folderpth".text = modpath
			main.checkFormetaData()
	
	return true
	pass


func _addBaseFiles(modpath):
	if file.open(modpath.plus_file("modmain.gd"), file.WRITE) == OK:
		pass
	else:
		return false
	file.store_string(\
"""extends Node

func _init(ml = ModLoader):
	pass

""")
	file.close()
	
	var _name = "Name that others write if it's a depency" if main.mod_name == '' else main.mod_name
	
	if file.open(modpath.plus_file("_metadata"), file.WRITE) == OK:
		pass
	else:
		return false
	
	file.store_string("""{
	"name": "{mod_name}",
	"friendly_name": "Name that shows in modlist",
	"description": "Put your description here",
	"author": "PlaceHolder",
	"version": "0.0.0",
	"link": "",
	"id": "00001",
	"requires": [""],
	"overwrites": false,
	"client_side": false,
	"priority": 0,
}""".format({"mod_name": _name}))
	
	file.close()
	
	return true


func _createBlank(mod_name):
	print("Created Blank Mod")
	pass
