tool
extends Tabs

onready var YHMAGlobal = find_parent("YHMA")

func _ready():
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_request_completed")
	var err = http.request("https://api.github.com/repos/{owner}/{repo}/releases/tags/{tag}".format(
		{
			"owner":"Valkarin1029",
			"repo":"YHModAssistant",
			"tag":YHMAGlobal.PLUGIN_VERSION
		}
	))
	
	if err != OK:
		push_warning("[YHMA] Unable to send api request")

func _request_completed(result, response_number, headers, body):
	
	if response_number != 200:
		if response_number == 404:
			return
		push_warning("[YHMA] Failed to contact github api")
		return
	
	var response = parse_json(body.get_string_from_utf8())
	
	$VBoxContainer/VBoxContainer/RichTextLabel.bbcode_text = response["body"].replace("#","[b]")
	
	pass
