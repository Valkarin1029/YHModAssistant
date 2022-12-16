tool
extends RichTextLabel

func _ready():
	
	
	var version = ''
	
	var file = File.new()
	
	file.open("res://addons/YHModAssistant/plugin.cfg", File.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line.match("version=*"):
			version = line.rsplit('"', false)[-1]
			break
	file.close()
#	print(version)
	
	
	self.bbcode_text = "[center][b][i][u]Version {version}[/u][/i][/b][/center]".format({"version": version})
