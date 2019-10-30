extends Node

onready var menu_singleton = get_node("/root/menu_singleton")

func _ready():
	# Define each menu
	var button_text = [ 
		{
			'name': 'File',
			'options': [
				{
					'text': 'New Project',
					'shortcut': 'CTRL+N'
				},
				{
					'text': 'Open Project',
					'shortcut': 'CTRL+O'
				},
				{
					'seperator': true,
				},
				{
					'text': 'Save Project',
					'shortcut': 'CTRL+S'
				},
				{
					'text': 'Save Project As',
					'shortcut': 'CTRL+SHIFT+S'
				}
			]
		},
		{
			'name': 'Edit',
			'options': [
				{
					'text': 'Undo',
					'shortcut': 'CTRL+Z'
				},
				{
					'text': 'Redo',
					'shortcut': 'CTRL+SHIFT+Z'
				},
				{
					'seperator': true,
				},
				{
					'text': 'Find Node',
					'shortcut': 'CTRL+F'
				}
			]
		},
		{
			'name': 'Help',
			'options': [
				{
					'text': 'About',
					'shortcut': 'CTRL+H'
				},
				{
					'text': 'Get Help',
				},
				{
					'seperator': true,
				},
				{
					'text': 'Commmunity',
				}
			]
		}
	]
	
	# lets add our menu items
	# see: menu_singleton
	menu_singleton.populate(self.get_path(), button_text)

func _on_item_pressed(ID):
    print(ID, " pressed")