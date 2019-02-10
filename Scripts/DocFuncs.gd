extends VBoxContainer

func _ready():
	populate_funcs()

func _physics_process(delta):
	if EditorSingleton.has_player_singleton and !EditorSingleton.loaded_player_funcs:
		print('we loaded our Player Singleton!')
		clear_funcs()
		populate_funcs()
		EditorSingleton.loaded_player_funcs = true

func populate_funcs():
	if EditorSingleton.has_player_singleton:
		var PlayerSingleton = get_node('/root/PlayerSingleton')
		for i in range(0, PlayerSingleton.functions.size()):
			var node = get_node("item_template").duplicate()
			node.get_child(0).set_text(PlayerSingleton.functions[i])
			node.set_name(PlayerSingleton.variables[i])
			node.get_child(1).set_text(PlayerSingleton.functionDocs[i])
			node.show()
			get_node(".").add_child(node)
	else:
		for i in range(0, DemoSingleton.functions.size()):
			var node = get_node("item_template").duplicate()
			node.get_child(0).set_text(DemoSingleton.functions[i])
			node.set_name(DemoSingleton.variables[i])
			node.get_child(1).set_text(DemoSingleton.functionDocs[i])
			node.show()
			get_node(".").add_child(node)

func clear_funcs():
	for i in range(1, get_child_count()):
		self.get_child(i).queue_free()

func reset():
	clear_funcs()
	EditorSingleton.loaded_player_funcs = false
	populate_funcs()
