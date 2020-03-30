extends Node

var settings_node
var settings_obj
onready var scene_nodes = serializer_singleton.scene.nodes
	
func default(path : String, obj : Array) -> void:
	settings_node = get_node(path)
	settings_obj = obj
	
	list_options(obj, 'editor')

func node_settings(obj : Array, node_name: String) -> void:
	list_options(obj, node_name)

func editor_settings() -> void:
	list_options(settings_obj, 'editor')

func list_options(settings_obj : Array, node_name: String) -> void:
	# first, clear our options
	for i in range(0, settings_node.get_child_count()):
		settings_node.get_child(i).queue_free()
	
	for setting in settings_obj:
		option_factory(setting, node_name)

func option_factory(settings : Dictionary, node_name: String) -> void:
	if 'name' in settings:
		# these fields are required
		var container = create_container(settings['name'])
		var node : Node
		
		# are we explicitly declaring a type
		if 'type' in settings:
			var type = settings['type']
			
			# are we a text node?
			if type == 'line' or type == 'text':
				node = create_text(type, settings, node_name)
		else:
			node = create_text('line', settings, node_name)
		
		container.add_child(node)
		
		# wire events to serializer
		node.connect("text_changed", serializer_singleton, 'save_setting', [settings['name'], node_name])
		
	else:
		print("[ERROR]: Missing name attribute")

func create_container(name : String) -> Node:
	var margin_node = MarginContainer.new()
	margin_node.set("custom_constants/margin_top", 5)
	margin_node.set("custom_constants/margin_left", 10)
	margin_node.set("custom_constants/margin_right", 10)
	
	var vbox_node = VBoxContainer.new()
	vbox_node.set("custom_constants/separation", 2)
	
	var label_node = Label.new()
	label_node.text = name
	label_node.uppercase = true
	label_node.add_font_override('font', load("res://assets/fonts/resources/roboto_reg_sm.tres"))
	
	margin_node.add_child(vbox_node)
	vbox_node.add_child(label_node)
	settings_node.add_child(margin_node)
	
	return vbox_node

func create_text(type : String, settings : Dictionary, node_name : String) -> Node:
	var text_node
	
	if type == 'text':
		text_node = TextEdit.new()
		text_node.rect_min_size = Vector2(100, 65)
		text_node.wrap_enabled = true
		
		if 'placeholder' in settings:
			text_node.text = settings['placeholder']
	else:
		text_node = LineEdit.new()
		if 'placeholder' in settings:
			text_node.placeholder_text = settings['placeholder']
	
	text_node.add_font_override('font', load("res://assets/fonts/resources/roboto_reg.tres"))
	
	# do we have a value?
	if 'value' in settings:
		text_node.set_text(settings['value'])

	# are we read only?
	if 'readonly' in settings:
		text_node.editable = !settings['readonly']
	
	# do we have a value saved?
	if 'name' in settings:
		if node_name in scene_nodes and settings['name'] in scene_nodes[node_name]:
			text_node.set_text(scene_nodes[node_name][settings['name']])
	
	return text_node
