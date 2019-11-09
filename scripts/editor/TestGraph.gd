extends GraphEdit

onready var start_node = load("res://config/nodes/start/node.tscn")
onready var test_node = load("res://config/nodes/dialogue/node.tscn")
onready var node_theme = self.get_theme()

func _ready():
	node_theme.set_constant("title_h_offset", "GraphNode", -5)
	node_theme.set_constant("close_h_offset", "GraphNode", 10)
	
	self.add_child(start_node.instance())
	self.add_child(test_node.instance())

func _on_Node_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)

func _on_Node_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
