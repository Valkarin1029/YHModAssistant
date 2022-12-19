tool
extends MenuButton


onready var main = $"../../.."

var dir = Directory.new()
var file = File.new()

var modpath = ''

func _init():
	if not get_popup().is_connected("id_pressed", self, "_createTemplate"):
		get_popup().connect("id_pressed", self, "_createTemplate")

func _ready():
	main = $"../../.."

func _on_MakeTemplate_about_to_show():
#	print("test")
	
	pass # Replace with function body.

func _createTemplate(id):
#	print(typeof(id))
	main = $"../../.."
	
	print(get_popup().get_item_text(id))
	
	if id == 0:
		
		if not _setup(main.mod_name):
			return
		
		_createBlank(main.mod_name)
	elif id == 1:
		if not _setup(main.mod_name):
			return
		
		_createCharacter(main.mod_name)
		
		pass
	elif id == 2:
		if not _setup(main.mod_name):
			return
		
		_createOverwrites(main.mod_name)
		
		pass
	
	EditorPlugin.new().get_editor_interface().get_resource_filesystem().scan()


func _setup(_name):
	modpath = ''
	
	if not _createDir(_name):
		return false
		
	if not _addBaseFiles(modpath):
		push_warning("Failed to add base files")
		return false
	else:
		main.checkFormetaData()
	
	return true
	


func _createDir(mod_name):
	
	if mod_name == '':
		push_error("Name cannot be blank. Please put a name in Mod Name")
		return false
	
	if dir.dir_exists("res://%s" % mod_name):
		push_error("Directory already exists! Delete the directory or change the name")
		return false
	
	if dir.make_dir("res://%s" % mod_name) == OK:
		modpath = "res://%s" % mod_name
		
		main.modfldrpth = modpath
		$"%Folderpth".text = modpath
		
	
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
	
	file.store_string(\
"""{
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
	print("Created Blank Mod Template")
	pass

func _createCharacter(mod_name):
	var characterDir = modpath+"/characters/"+mod_name
	if dir.make_dir_recursive(characterDir+'/') != OK:
		printerr("Failed to make character directory")
		return false
	
	var dirToMake = ['/sprites', '/states', '/sounds', '/projectiles', '/ActionUiData']
	
	for directory in dirToMake:
		if dir.make_dir(characterDir+directory) != OK:
			push_error("Failed to make sub directories for the character")
			return false
	
	if file.open(modpath.plus_file("modmain.gd"), File.WRITE) != OK:
		push_error("Failed to open modmain.gd")
		return false
	else:
		file.store_string(
"""extends Node

func _init(ml = ModLoader):
	ml.installScriptExtension("res://{name}/CharacterSelect.gd")
	

""".format(\
{"name":mod_name,"path": modpath+"/characters/"+mod_name+".tscn"}))
	
		file.close()
		
	if file.open(modpath.plus_file("CharacterSelect.gd"), file.WRITE) != OK:
		push_error("Failed to open CharacterSelect.gd")
		return false
	else:
		file.store_string(\
"""extends "res://ui/CSS/CharacterSelect.gd"

func _ready():
	addCustomChar("{name}", "{characterDir}")
	

""".format(\
{"name":mod_name, "characterDir":characterDir.plus_file(mod_name+'.tsnc')}))
	
		file.close()
	
	var baseChar = load("res://characters/BaseChar.tscn")
	
	var newChar = PackedScene.new()
	
	newChar._bundled = {"base_scene": 0, "conn_count": 0, "conns": [], "editable_instances": [], 
	"names": [mod_name], "node_count": 1, "node_paths": [], 
	"nodes": [-1, -1, 2147483647, 0, -1, 0, 0], 
	"variants": [baseChar], "version": 2}
	
	var err = ResourceSaver.save(characterDir+"/"+mod_name+".tscn", newChar)
	if err != OK:
		push_error("Failed to save baseChar")

	print("Created Character Mod Template")

func _createOverwrites(mod_name):
	var name_paths = {
	"Ninja":"res://characters/stickman/NinjaGuy.tscn", 
	"Cowboy":"res://characters/swordandgun/SwordGuy.tscn", 
	"Wizard":"res://characters/wizard/Wizard.tscn", 
	"Robot":"res://characters/robo/Robot.tscn", 
	}
	
	var OverwritesFolder = modpath+'/Overwrites'
	
	if dir.make_dir(OverwritesFolder) != OK:
		push_error("Failed to make Overwrites folder")
		return false
	
	for chars in name_paths.keys():
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/Sounds')
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/StateSounds')
		
		if file.file_exists(name_paths.get(chars)):
			var instCharTS = load(name_paths.get(chars)).instance()
			var instCharAnim = instCharTS.get_node("Flip/Sprite")
			var instCharFrames = instCharAnim.get_sprite_frames()
#			print(instCharFrames.get_animation_names())
			for animation in instCharFrames.get_animation_names():
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/'+animation)
			
			if chars == "Cowboy":
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/ShootingArm/default')
			elif chars == "Wizard":
				dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/LiftoffAir/defualt')
			
			instCharTS.free()
		else:
			continue
		
		
	print("Overwrites mod made")
