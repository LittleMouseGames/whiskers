extends Node

var settings_node
var settings_obj
onready var scene_nodes = serializer_singleton.scene.nodes
	
func default(path : String, obj : Dictionary) -> void:
	settings_node = get_node(path)
	settings_obj = obj
	
	list_options(obj, 'editor')

func node_settings(obj : Dictionary, node_name : String) -> void:
	list_options(obj, node_name)

func editor_settings() -> void:
	list_options(settings_obj, 'editor')

func list_options(settings_obj : Dictionary, node_name: String) -> void:
	# first, clear our options
	for i in range(0, settings_node.get_child_count()):
		settings_node.get_child(i).queue_free()
	
	for setting in settings_obj:
		option_factory(setting, settings_obj[setting], node_name)

func option_factory(name: String, settings : Dictionary, node_name: String) -> void:
	var nodeType;
	# adds title to box
	var box_title = settings_node.get_parent().get_parent().get_node('TitleContainer').get_node('SettingsTitle')
	if node_name == 'editor': 
		box_title.set_text('Scene Settings')
	else:
		box_title.set_text('Node Settings')
	
	var container = create_container(name)
	var node : Node
		
	# are we explicitly declaring a type
	if 'type' in settings:
		var type = settings['type']
		nodeType = type
			
		# are we a text node?
		if type == 'line' or type == 'text':
			node = create_text(type, settings, node_name)
		elif type == 'option':
			node = create_dropdown(settings, node_name)
	else:
		node = create_text('line', settings, node_name)
		nodeType = 'line'
		
	node.name = name
	container.add_child(node)
		
	# wire events to serializer
	if nodeType == 'line':
		node.connect("text_changed", serializer_singleton, 'save_setting', [name, node_name])
	elif nodeType == 'text':
		node.connect("text_changed", serializer_singleton, 'save_setting', [null, name, node_name])
	elif nodeType == 'option':
		node.connect("item_selected", serializer_singleton, 'save_selection', [name, node_name])

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
	
	return text_node

func create_dropdown(settings : Dictionary, node_name : String) -> Node:
	var option_node = OptionButton.new()
	
	# add our options to our dropdown
	if 'options' in settings and not 'character_select' in settings:
		var options = settings['options']
		
		for option in options:
			option_node.add_item(option)
	elif 'character_select' in settings:
		var characters = serializer_singleton.get_characters()
		
		for character in characters:
			option_node.add_item(characters[character].name)
	
	if 'value' in settings:
		option_node.select(settings['value'])

	return option_node

func get_value(setting_name: String) -> String:
	return settings_node.find_node(setting_name, true, false).text
