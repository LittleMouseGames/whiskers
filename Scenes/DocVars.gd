extends VBoxContainer

func _ready():
	for i in range(0, DemoSingleton.variables.size()):
		var node = get_node("item_template").duplicate()
		node.get_child(0).set_text(DemoSingleton.variables[i])
		node.set_name(DemoSingleton.variables[i])
		node.get_child(1).set_text(str(DemoSingleton.get(DemoSingleton.variables[i])))
		node.show()
		get_node(".").add_child(node)

func _on_LineEdit_text_changed(new_text):
	var items = get_node(".").get_child_count()
	for i in range(1, items):
		var nodeText = get_node(".").get_child(i).get_child(1).get_text()
		if(nodeText == new_text):
			var val = new_text
			if(new_text == 'True') or (new_text == 'true'):
				val = true
			if(new_text == 'False') or (new_text == 'false'):
				val = false
			DemoSingleton.set(get_node(".").get_child(i).name, val)
