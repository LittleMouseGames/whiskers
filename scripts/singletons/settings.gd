extends Node

var settings_path
var settings_obj
var on_node = false

func save_path(path : String, obj : Array) -> void:
	settings_path = path;
	settings_obj = obj
	
	list_options()

func list_options() -> void:
	for setting in settings_obj:
		var margin_node = MarginContainer.new()
		margin_node.set("custom_constants/margin_top", 5)
		margin_node.set("custom_constants/margin_left", 10)
		margin_node.set("custom_constants/margin_right", 10)
		
		var vbox_node = VBoxContainer.new()
		vbox_node.set("custom_constants/separation", 2)
		
		var label_node = Label.new()
		label_node.text = setting['name']
		label_node.uppercase = true
		label_node.add_font_override('font', load("res://assets/fonts/resources/roboto_reg_sm.tres"))
		
		var line_node = LineEdit.new()
		line_node.placeholder_text = setting['placeholder']
		line_node.add_font_override('font', load("res://assets/fonts/resources/roboto_reg.tres"))
		
		margin_node.add_child(vbox_node)
		vbox_node.add_child(label_node)
		vbox_node.add_child(line_node)
		
		get_node(settings_path).add_child(margin_node)
	
	get_node(settings_path).get_child(settings_obj.size() - 1).set("custom_constants/margin_bottom", 10)
	get_node(settings_path).get_child(0).set("custom_constants/margin_top", 8)
