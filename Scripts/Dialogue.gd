extends Panel

var dialogueAsset
var data
var lastBttnPos = 0
var buttonFired = false
var timer = 0

func _process(delta):
	timer += delta
	for i in range(0, get_node("Buttons").get_child_count()):
		if get_node('Buttons').get_child(i).pressed and !buttonFired and timer >= 0.5:
			var name = get_node('Buttons').get_child(i).name
			if('@' in name):
				name = name.split('@')[1]
				if('@' in name):
					name = name.split('@')[0]
			_next(name, false)
			buttonFired = true
	if(buttonFired):
		timer = 0
		buttonFired = false

func _populate():
	if(data) and (data.size() > 1):
		# do we have a character name?
		get_node("Name").set_text(data['info']['display_name'])
		get_node("Name").show()
		# load the first bit of Data
		var firstNode = data[data['Start']['connects_to'][1]]
		get_node("Text").parse_bbcode(firstNode['text'])
		# lets set our buttons
		var firstButtons = firstNode['connects_to'].size()
		for i in range(1, firstButtons+1):
			_handle_action(firstNode['connects_to'][i], 'dialogue')

func _next(name, fromLogic): # Its for a church honey!
	var button = data[name]
	#lets clear our buttons
	_clearButtons()
	for i in range(1, button['connects_to'].size()+1):
		if('Dialogue' in button['connects_to'][i]):
			# lets load that Dialogue node!
			get_node("Text").parse_bbcode(data[button['connects_to'][i]]['text'])
			# lets load everything we're connecting to!
			var connectedTo = data[button['connects_to'][i]]['connects_to']
			for x in range(1, connectedTo.size()+1):
				_handle_action(connectedTo[x], 'dialogue')
		
		_handle_action(button['connects_to'][i], 'option')
	
	if(fromLogic):
		get_node("Text").parse_bbcode(button['text'])
		for i in range(1, button['connects_to'].size()+1):
			_handle_action(button['connects_to'][i], 'dialogue')

func _handle_action(name, from):
	if('Option' in name):
		_addButton(data[name]['text'], name)
	if('Condition' in name):
		_parse_logic(name, from)
	if('Expression' in name):
		_fire_expression(name)
	if('Jump' in name):
		_jump_to(name)

func _parse_logic(currentNode, from):
	# we should find our expression node!
	var dataKeys = data.keys()
	for z in range(0, data.size()):
		if('Expression' in dataKeys[z]) and (data[dataKeys[z]]['connects_to'][1] == currentNode):
			# lets store our logic in the new Expression type!
			var expression = Expression.new()
			expression.parse(data[dataKeys[z]]['logic'], [])
			var result = expression.execute([], DemoSingleton, true)
			var routes = data[currentNode]['conditions']
			if not expression.has_execute_failed():
				if(from == 'dialogue'):
					if(result):
						_addButton(data[routes['true']]['text'], routes['true'])
					else:
						_addButton(data[routes['false']]['text'], routes['false'])
				else:
					if(result):
						_next(routes['true'], true)
					else:
						_next(routes['false'], true)
			else:
				# something failed, we'll default to false.
				if(from == 'dialogue'):
					_addButton(data[routes['false']]['text'], routes['false'])
				else:
					_next(routes['false'], true)

func _fire_expression(name):
	print('firing expression!')
	var logic = data[name]['logic']
	var expression = Expression.new()
	expression.parse(logic, [])
	var result = expression.execute([], DemoSingleton, true)
	if not expression.has_execute_failed():
		if(result):
			print('expression executed!')
	else:
		print('expression failed!')

func _jump_to(name):
	var jumpKey = data[name]['text']
	var dataKeys = data.keys()
	for z in range(0, data.size()):
		if('Jump' in dataKeys[z]) and (dataKeys[z] != name) and (data[dataKeys[z]]['text'] == jumpKey):
			if ('Dialogue' in data[dataKeys[z]]['connects_to'][1]):
				var node = data[data[dataKeys[z]]['connects_to'][1]]
				get_node("Text").parse_bbcode(node['text'])
				for i in range(1, node['connects_to'].size()+1):
					_handle_action(node['connects_to'][i], 'dialogue')
			else:
				_handle_action(data[dataKeys[z]]['connects_to'][1], 'dialogue')

func _addButton(text, bttnName):
	var node = Button.new()
	var template = get_node("Template")
	node.rect_size = template.rect_size
	node.rect_position = Vector2(template.rect_position.x, template.rect_position.y + lastBttnPos)
	node.set_text(text)
	self.get_node("Buttons").add_child(node)
	node.show()
	node.set_name(bttnName)
	lastBttnPos -= 35#? Yes, yes. I've thought it over quite thoroughly

func _reset():
	data = 0
	buttonFired = false
	lastBttnPos = 0
	_clearButtons()
	EditorSingleton._update_demo()
	get_node("Name").hide()

func _clearButtons():
	lastBttnPos = 0
	for child in get_node("Buttons").get_children():
		child.queue_free()