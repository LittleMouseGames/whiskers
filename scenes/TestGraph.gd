extends GraphEdit

onready var test_node = load("res://config/nodes/start/node.tscn")
onready var node_theme = self.get_theme()

func _ready():
	node_theme.set_constant("title_h_offset", "GraphNode", -5)
	node_theme.set_constant("close_h_offset", "GraphNode", 10)
	
	test_node = test_node.instance()
	self.add_child(test_node)
