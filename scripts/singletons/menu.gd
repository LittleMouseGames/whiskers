extends Node

# List our key codes
# There has got to be a better way
var keys = {
	'A': 65,
	'B': 66,
	'C': 67,
	'D': 68,
	'E': 69,
	'F': 70,
	'G': 71,
	'H': 72,
	'I': 73,
	'J': 74,
	'K': 75,
	'L': 76,
	'M': 77,
	'N': 78,
	'O': 79,
	'P': 80,
	'Q': 81,
	'R': 82,
	'S': 83,
	'T': 84,
	'U': 85,
	'V': 86,
	'W': 87,
	'X': 88,
	'Y': 89,
	'Z': 90
}

func populate(menu_path : String, button_text : Array) -> void:
	var idScope = 0
	for item in button_text:
		# add our menu button
		var menu_node = get_node(menu_path)
		var button = MenuButton.new()
		button.name = item['name']
		button.text = item['name']
		button.switch_on_hover = true
		menu_node.add_child(button)
		
		var node = menu_node.get_node(item['name'])
		var popup = node.get_popup()
		var index = 0
		var id = idScope
		idScope += 100 
		
		for option in item['options']:
			if 'text' in option:
				id += 1
				popup.add_item( option['text'] )
				popup.set_item_id( index, id )
				popup.connect("id_pressed", menu_node, "_on_item_pressed")
			
			if 'seperator' in option:
				popup.add_separator()
				index += 1
			
			if 'shortcut' in option:
				var text = option['shortcut']
				
				# Create the shortcut
				var shortcut = ShortCut.new()
				var inputeventkey = InputEventKey.new()
				
				if text[ len(text) - 1 ] in keys:
					inputeventkey.set_scancode( keys[text[ len(text) - 1 ]] )
				
				if 'CTRL' in text:
					inputeventkey.control = true
				if 'SHIFT' in text:
					inputeventkey.shift = true
				
				shortcut.set_shortcut(inputeventkey)
	
				# Set shortcut
				popup.set_item_shortcut(index, shortcut, true)
				index += 1