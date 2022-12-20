tool
extends Control


var mod_name = ''
var modfldrpth = ''
var EXPORTPATH = OS.get_executable_path().get_base_dir().plus_file("mods")

var new_version = false

func _ready():
	var folderpath = ProjectSettings.globalize_path("res://addons/YHModAssistant")
	var output = []
	OS.execute("cmd.exe", ['/c','cd "{path}" && git diff'.format({'path':folderpath})], true, output)
	
	var new_versionsTags = output[0].split("\n")
	for x in new_versionsTags:
		if x.match("*[new tag]*"):
			new_version = true
	
#	print(output)
#	get_node("UI/VBoxContainer/Update").visible = new_version
	
	EXPORTPATH = OS.get_executable_path().get_base_dir().plus_file("mods")
	$"%ExportPath".placeholder_text = EXPORTPATH


func checkFormetaData(useMetaName = false):
	var file = File.new()
	if not file.file_exists(modfldrpth.plus_file("_metadata")):
		$"%CreatemetaDataBtn".visible = true
		$"%EditmetaDataBtn".visible = false
	else:
		$"%CreatemetaDataBtn".visible = false
		$"%EditmetaDataBtn".visible = true
		
	if useMetaName:
		var _name = ''

		file.open(modfldrpth.plus_file("_metadata"), File.READ)
		var contents = JSON.parse(file.get_as_text()).result
		file.close()
		if contents.has('name'):
			_name = contents.get('name')
		if _name == $"%ModNameTB".text:
			print("Name matches meta_data")
		else:
			$"%ModNameTB".text = _name









