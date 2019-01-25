extends VBoxContainer

func _ready():
	for i in range(0, DemoSingleton.functions.size()):
		var node = get_node("item_template").duplicate()
		node.get_child(0).set_text(DemoSingleton.functions[i])
		node.set_name(DemoSingleton.variables[i])
		node.get_child(1).set_text(DemoSingleton.functionDocs[i])
		node.show()
		get_node(".").add_child(node)
