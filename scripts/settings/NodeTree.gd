extends Tree

onready var tree_item_script = load("res://scripts/settings/TreeItem.gd")
var dialogue_group
var option_group

func _ready():
	# add the root scene node
	self.create_item(self).set_text(0, "Scene")
	
	dialogue_group = self.create_item(self)
	dialogue_group.set_text(0, "Dialogue Nodes")
	
	option_group = self.create_item(self)
	option_group.set_text(0, "Option Nodes")

func add_to_tree(group, info):
	if 'dialogue' in group:
		var tree_item = self.create_item(dialogue_group)
		tree_item.set_text(0, info)
		tree_item.set_script(tree_item_script)
		tree_item.node_name = info

func remove_from_tree(group, name):
	print(dialogue_group.get_children())
	if 'dialogue' in group:
		var child = dialogue_group.get_children()
		while child != null:
			if "node_name" in child and child.node_name == name:
				dialogue_group.remove_child(child)
				self.update()
		
			child = child.get_next()

func update_name(node_name, new, node_type):
	if 'Dialogue' in node_type:
		var child = dialogue_group.get_children()
		while child != null:
			if child.get_text(0) == node_name or child.node_name == node_name:
				child.node_name = node_name
				child.set_text(0, new)
				self.update()
			
			child = child.get_next()
