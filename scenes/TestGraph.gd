extends GraphEdit

onready var test_node = load("res://config/nodes/start/node.tscn")

func _ready():
	test_node = test_node.instance()
	self.add_child(test_node)
