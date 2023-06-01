tool
extends VBoxContainer

signal load_mod_info(update_info_tab)

var current_mod_path

func _ready():
	var output = []
	var git_path = "res://addons/YHModAssistant/Extras/PortableGit/cmd"
	var assistant_path = "res://addons/YHModAssistant"
	git_path = ProjectSettings.globalize_path(git_path)
	assistant_path = ProjectSettings.globalize_path(assistant_path)
	
	OS.execute("CMD.exe",
			["/C", 'cd {git_path} && git pull "{assistant_path}"'.format(
				{
					"git_path":git_path,
					"assistant_path":assistant_path
				}
			)],
			true,
			output,
			true,
			false
			)
	
#	printt(output)
	
	if not output[0].match("*Already up to date*"):
		change_scene("RestartRequired")
		print(output[0])
	else:
		change_scene("Home")

func change_scene(scene):
	if scene == null:
		printerr("Scene could not be loaded -YH Assistant")
		return
	
	for node in get_children():
		if node.name == scene:
			node.visible = true
		else:
			node.visible = false
	


