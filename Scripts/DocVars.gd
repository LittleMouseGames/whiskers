extends VBoxContainer

var isFocused = false
var loadingData = false

func _ready():
	populate_vars()

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
			if(get_node('/root/PlayerSingleton')):
				get_node('/root/PlayerSingleton').set(get_node(".").get_child(i).name, val)
			else:
				DemoSingleton.set(get_node(".").get_child(i).name, val)

func _physics_process(delta):
	if (!isFocused) and (!loadingData):
		var items = get_node(".").get_child_count()
		for i in range(1, items):
			if EditorSingleton.hasPlayerSingleton:
				get_node(".").get_child(i).get_child(1).set_text(str(get_node('/root/PlayerSingleton').get(get_node(".").get_child(i).name)))
			else:
				get_node(".").get_child(i).get_child(1).set_text(str(DemoSingleton.get(get_node(".").get_child(i).name)))
	
	if EditorSingleton.hasPlayerSingleton and !EditorSingleton.loadedPlayerVars:
		loadingData = true
		clear_vars()
		populate_vars()
		EditorSingleton.loadedPlayerVars = true

func _on_LineEdit_focus_entered():
	isFocused = true

func _on_LineEdit_focus_exited():
	isFocused = false

func populate_vars():
	if EditorSingleton.hasPlayerSingleton:
		var PlayerSingleton = get_node('/root/PlayerSingleton')
		for i in range(0, PlayerSingleton.variables.size()):
			var node = get_node("item_template").duplicate()
			node.get_child(0).set_text(PlayerSingleton.variables[i])
			node.set_name(PlayerSingleton.variables[i])
			node.hint_tooltip = PlayerSingleton.varTooltips[i]
			node.get_child(1).set_text(str(PlayerSingleton.get(PlayerSingleton.variables[i])))
			node.show()
			get_node(".").add_child(node)
	else:
		for i in range(0, DemoSingleton.variables.size()):
			var node = get_node("item_template").duplicate()
			node.get_child(0).set_text(DemoSingleton.variables[i])
			node.set_name(DemoSingleton.variables[i])
			node.hint_tooltip = DemoSingleton.varTooltips[i]
			node.get_child(1).set_text(str(DemoSingleton.get(DemoSingleton.variables[i])))
			node.show()
			get_node(".").add_child(node)
	loadingData = false

func clear_vars():
	for i in range(1, get_child_count()):
		self.get_child(i).queue_free()

func reset():
	clear_vars()
	EditorSingleton.loadedPlayerVars = false
	populate_vars()