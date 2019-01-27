extends VBoxContainer

func _ready():
	for i in range(0, DemoSingleton.functions.size()):
		var node = get_node("item_template").duplicate()
		node.get_child(0).set_text(DemoSingleton.functions[i])
		node.set_name(DemoSingleton.variables[i])
		node.get_child(1).set_text(DemoSingleton.functionDocs[i])
		node.show()
		get_node(".").add_child(node)

func _physics_process(delta):
	if(EditorSingleton.hasPlayerSingleton) and (!EditorSingleton.loadedPlayerFuncs):
		print('we loaded our Player Singleton!')
		_clear_funcs()
		_populate_funcs()
		EditorSingleton.loadedPlayerFuncs = true

func _populate_funcs():
	var PlayerSingleton = get_node('/root/PlayerSingleton')
	for i in range(0, PlayerSingleton.functions.size()):
		var node = get_node("item_template").duplicate()
		node.get_child(0).set_text(PlayerSingleton.functions[i])
		node.set_name(PlayerSingleton.variables[i])
		node.get_child(1).set_text(PlayerSingleton.functionDocs[i])
		node.show()
		get_node(".").add_child(node)

func _clear_funcs():
	for i in range(1, get_child_count()):
		self.get_child(i).queue_free()