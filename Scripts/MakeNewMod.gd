tool
extends ScrollContainer

var mod_type = "blank"

onready var main = $".."

var dir = Directory.new()
var file = File.new()

var modpath = ''

func _ready():
	main = $".."

func _on_Cancel_pressed():
	self.visible = false
	$"%Menu".visible = true

func _on_Create_pressed():
	main = $".."
	
	
	if $"%ModNameNewTB".text == '':
		push_error("Name cannot be empty")
		return
	elif $"%ModFriendlyNameNameTB".text == '':
		push_error("Friendly name cannot be empty")
		return
	elif $"%Description".text == '':
		push_error("Description cannot be empty")
		return
	elif $"%AuthorTL".text == '':
		push_error("Author name cannot be empty")
		return
	
	var modName = $"%ModNameNewTB".text
	
	if mod_type == 'blank':
		
		if not _setup(modName):
			return
		
		_createBlank(modName)
	elif mod_type == 'character':
		if not _setup(modName):
			return
		
		_createCharacter(modName)
		
		pass
	elif mod_type == 'overwrite':
		if not _setup(modName):
			return
		
		_createOverwrites(modName)
		
		pass
	
	self.visible = false
	$"%Loaded".visible = true
	
	
	$"%ModNameTB".text = $"%ModNameNewTB".text
	$"%Folderpth".text = main.modfldrpth
	
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
	
	
	if file.open(modpath.plus_file("_metadata"), file.WRITE) == OK:
		pass
	else:
		return false
	
	file.store_string(\
"""{
	"name": "{mod_name}",
	"friendly_name": "{friendly_name}",
	"description": "{description}",
	"author": "{author}",
	"version": "0.0.0",
	"link": "",
	"id": "00001",
	"requires": [""],
	"overwrites": false,
	"client_side": false,
	"priority": 0,
}""".format({
	"mod_name": $"%ModNameNewTB".text,
	"friendly_name": $"%ModFriendlyNameNameTB".text,
	"description": $"%Description".text,
	"author": $"%AuthorTL".text,
	}))
	
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
	

""".format({
	"name":mod_name,
	"path": modpath+"/characters/"+mod_name+".tscn",
	}))
	
		file.close()
		
	if file.open(modpath.plus_file("CharacterSelect.gd"), file.WRITE) != OK:
		push_error("Failed to open CharacterSelect.gd")
		return false
	else:
		file.store_string(\
"""extends "res://ui/CSS/CharacterSelect.gd"

func _ready():
	addCustomChar("{name}", "{characterDir}")
	

""".format({
	"name":mod_name, 
	"characterDir":characterDir.plus_file(mod_name+'.tsnc')
	}))
	
		file.close()
	
	
	if file.open(modpath.plus_file("_metadata"), file.WRITE) == OK:
		pass
	else:
		return false
	
	file.store_string(\
"""{
	"name": "{mod_name}",
	"friendly_name": "{friendly_name}",
	"description": "{description}",
	"author": "{author}",
	"version": "0.0.0",
	"link": "",
	"id": "00001",
	"requires": ["char_loader"],
	"overwrites": false,
	"client_side": false,
	"priority": 0,
}""".format({
	"mod_name": $"%ModNameNewTB".text,
	"friendly_name": $"%ModFriendlyNameNameTB".text,
	"description": $"%Description".text,
	"author": $"%AuthorTL".text,
	}))
	
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
	var global = load("res://Global.gd").new()
	
	var OverwritesFolder = modpath+'/Overwrites'
	
	if dir.make_dir(OverwritesFolder) != OK:
		push_error("Failed to make Overwrites folder")
		return false
	
	for chars in global.name_paths.keys():
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/Sounds')
		dir.make_dir_recursive(OverwritesFolder+'/'+chars+'/StateSounds')
		
		if file.file_exists(global.name_paths.get(chars)):
			var instCharTS = load(global.name_paths.get(chars)).instance()
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
		
		
	
	global.free()
	
	if file.open(modpath.plus_file("_metadata"), file.WRITE) == OK:
		pass
	else:
		return false
	
	file.store_string(\
"""{
	"name": "{mod_name}",
	"friendly_name": "{friendly_name}",
	"description": "{description}",
	"author": "{author}",
	"version": "0.0.0",
	"link": "",
	"id": "00001",
	"requires": [""],
	"overwrites": true,
	"client_side": true,
	"priority": 0,
}""".format({
	"mod_name": $"%ModNameNewTB".text,
	"friendly_name": $"%ModFriendlyNameNameTB".text,
	"description": $"%Description".text,
	"author": $"%AuthorTL".text,
	}))
	
	file.close()
	
	print("Overwrites mod made")
	



