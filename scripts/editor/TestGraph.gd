extends GraphEdit

onready var start_node = load("res://config/nodes/start/node.tscn")
onready var test_node = load("res://config/nodes/dialogue/node.tscn")
onready var node_theme : Theme = self.get_theme()
var node_click : bool = true

func _ready():
	node_theme.set_constant("title_h_offset", "GraphNode", -5)
	node_theme.set_constant("close_h_offset", "GraphNode", 10)
	
	test_node = test_node.instance()
	test_node.connect("gui_input", self, "_on_Graph_click", [true])
	
	self.add_child(start_node.instance())
	self.add_child(test_node)

func _on_Node_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)

func _on_Node_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)


func _on_Node_selected(node):
	node.list_settings()

func _on_Graph_click(event, on_node):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if on_node:
				node_click = true
			else:
				if not node_click:
					settings_singleton.editor_settings()
				node_click = false
