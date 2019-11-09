extends Node

var settings_node
var settings_obj

func save_path(path : String, obj : Array) -> void:
	settings_node = get_node(path)
	settings_obj = obj
	
	list_options(obj)

func node_settings(obj : Array) -> void:
	list_options(obj)

func editor_settings() -> void:
	list_options(settings_obj)

func list_options(settings : Array) -> void:
	# first, clear our options
	for i in range(0, settings_node.get_child_count()):
		settings_node.get_child(i).queue_free()
	
	for setting in settings:
		option_factory(setting['name'], setting['placeholder'])

func option_factory(name : String, placeholder: String) -> void:
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
	
	var line_node = LineEdit.new()
	line_node.placeholder_text = placeholder
	line_node.add_font_override('font', load("res://assets/fonts/resources/roboto_reg.tres"))
	
	margin_node.add_child(vbox_node)
	vbox_node.add_child(label_node)
	vbox_node.add_child(line_node)
	
	settings_node.add_child(margin_node)
