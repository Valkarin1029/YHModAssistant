tool
extends ScrollContainer

func _ready():
	
	var http = $"%HTTPRequest"
	
	var response = http.request("https://api.github.com/repos/Valkarin1029/YHModAssistant/releases/latest")
	

#func _request_complete(result, response_code, headers, body):
#	var json = JSON.parse(body.get_string_from_utf8()).result
#	print(json)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8()).result
	
	_checkVersion(json['tag_name'])


func _checkVersion(tagName):
	var version = ''
	
	var file = File.new()
	
	file.open("res://addons/YHModAssistant/plugin.cfg", File.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line.match("version=*"):
			version = line.rsplit('"', false)[-1]
			break
	file.close()
	
	tagName = tagName.split('_')[0].lstrip('v')
	
	var vnums = version.split('.')
	var Tagvnums = tagName.split('.')
	
	for x in len(vnums):
		if vnums[x] == Tagvnums[x]:
			continue
		elif vnums[x] < Tagvnums[x]:
			$"%Update".visible = true
			return
	
	


func _on_Update_pressed():
	OS.shell_open("https://github.com/Valkarin1029/YHModAssistant/releases")


func _on_MakeNewMod_pressed():
	
	$"%ModNameNewTB".text = 'Place Holder'
	$"%ModFriendlyNameNameTB".text = 'Place Holder'
	$"%Description".text = 'Place Holder'
	$"%AuthorTL".text = 'Place Holder'
	
	
	
	$"%Menu".visible = false
	$"%ChooseTemplates".visible = true


func _on_LoadMod_pressed():
	$"%ModFolderPath".popup()





