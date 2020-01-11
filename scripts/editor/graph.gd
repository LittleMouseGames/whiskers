extends GraphEdit

onready var start_node = load("res://config/nodes/start/node.tscn")
onready var node_theme : Theme = self.get_theme()
var node_click : bool = true

func _ready():
	node_theme.set_constant("title_h_offset", "GraphNode", -5)
	node_theme.set_constant("close_h_offset", "GraphNode", 10)
	
	start_node = start_node.instance()
	start_node.connect("gui_input", self, "_on_Graph_click", [true])
	
	self.add_child(start_node)
	
	loader_singleton.graph_node = self.get_path()

func _on_Node_connection_request(from, from_slot, to, to_slot):
	# you can't connect to yourself
	if from != to:
		connect_node(from, from_slot, to, to_slot)

func _on_Node_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)

func _on_Node_selected(node):
	if node.has_method("list_settings"):
		node.list_settings()
	else:
		print('[WARN]: Missing `list_settings` on node' + ' ' + node.name)

func _on_Graph_click(event, on_node):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if on_node:
				node_click = true
			else:
				if not node_click:
					settings_singleton.editor_settings()
				node_click = false

# checks if we can recive the dropped data
func can_drop_data(pos, data):
	return true

func drop_data(pos, data):
	var localMousePos = self.get_child(1).get_local_mouse_position()
	loader_singleton.init_scene('dialogue', localMousePos)

func _close_Request(node):
	self.remove_child(node)
