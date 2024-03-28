tool
extends TextureRect

var frame = 0

func get_drag_data(position):
	var data = {
		"origin_node": self,
		"frame": frame,
		"origin_texture": texture,
	}
	
	printt(data)
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.rect_size = Vector2(100,100)
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(control)
	
	return data

func can_drop_data(position, data):
	
	return typeof(data) == TYPE_DICTIONARY and data.has("frame")

func drop_data(position, data):
	data["origin_node"].texture = texture
	
	texture = data["origin_texture"]
