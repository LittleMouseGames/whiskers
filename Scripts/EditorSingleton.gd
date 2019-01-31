extends Node

var inMenu = false
var test = true

var loadedPlayerVars = false
var loadedPlayerFuncs = false
var hasPlayerSingleton = false

# for history
var currentHistory = 0
var historyObj = {}

var nodeNames = ['Dialogue', 'Option', 'Expression', 'Condition', 'Jump', 'End', 'Start', 'Comment']
var hasGraph = false


func get_node_type(name):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	var result = regex.search(name)
	if result:
		return result.get_string()

func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("save"):
			close_all()
			get_node("/root/Editor/Mount/Modals/Save").show()
			get_node("/root/Editor/Mount/Modals/Save").current_file = get_node("/root/Editor/Mount/MainWindow/Editor/Info/Info/Name/Input").get_text()+'.json'
		if Input.is_action_pressed("open"):
			close_all()
			get_node("/root/Editor/Mount/Modals/Open").show()
		if Input.is_action_pressed("quit"):
			close_all()
			get_node("/root/Editor/Mount/Modals/QuitConf").show()
		if Input.is_action_pressed("help"):
			close_all()
			get_node("/root/Editor/Mount/Modals/About").show()
		if Input.is_action_pressed("new"):
			close_all()
			get_node("/root/Editor/Mount/Modals/New").show()
		if Input.is_action_pressed("import"):
			close_all()
			get_node("/root/Editor/Mount/Modals/Import").show()
		if Input.is_action_pressed("undo"):
			undo_history()
		if Input.is_action_pressed("redo"):
			redo_history()

func close_all():
	# modals
	get_node("/root/Editor/Mount/Modals/Save").hide()
	get_node("/root/Editor/Mount/Modals/Open").hide()
	get_node("/root/Editor/Mount/Modals/QuitConf").hide()
	get_node("/root/Editor/Mount/Modals/About").hide()
	get_node("/root/Editor/Mount/Modals/Import").hide()
	# menus
	get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/File/Menu").hide()
	get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/Help/Menu").hide()
	get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/Edit/Menu").hide()

func _input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				if(!inMenu):
					get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/File/Menu").hide()
					get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/Help/Menu").hide()
					get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/Edit/Menu").hide()

func update_demo():
	if hasGraph:
		get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph").process_data()
		get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Demo/Dialogue").data = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph").data

#===== History Management
func overwrite_history():
	if currentHistory > 0:
		var tempHistory = {}
		for i in range(0, currentHistory):
			tempHistory[i] = historyObj[i]
		# overwrite history with our temp / new one
		historyObj = tempHistory

func add_history(node, name, offset, text, connects_from, action):
	overwrite_history()
	historyObj[currentHistory] = {
			'node': node,
			'name': name,
			'offset': offset,
			'text': text,
			'connects_from': connects_from,
			'action': action
	}
	currentHistory += 1

func undo_history():
	var graph = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph")
	if historyObj.size() > 0 and currentHistory >= 2:
		# we're in the past
		var action = historyObj[currentHistory - 1]['action']
		var obj = historyObj[currentHistory - 1]
		
		print(action)
		if action == 'remove':
			graph.load_node(obj['node']+'.tscn', obj['offset'], obj['name'], obj['text'])
		if action == 'move':
			var lastInstance = historyObj[last_instance_of(obj['name'])]
			graph.get_node(obj['name']).set_offset(lastInstance['offset'])
		if action == 'text':
			var lastInstance = historyObj[last_instance_of(obj['name'])]
			graph.get_node(obj['name']).get_node("Lines").get_child(0).set_text(lastInstance['text'])
		if action == 'add':
			graph.get_node(obj['name']).queue_free()
		
		if 'connect' in action:
			if action == 'connect':
				print('disconnect node')
				var connections = graph.get_connection_list()
				for i in range(0, connections.size()):
					if connections[i].to == obj['name'] and not connections[i].from in obj['connects_from']:
						graph.disconnect_node(connections[i].from, 0, obj['name'], 0) 
			else:
				var lastInstance = historyObj[last_instance_of(obj['name'])]
				for i in range(0, lastInstance['connects_from'].size()):
					graph.connect_node(lastInstance['connects_from'][i+1], 0, obj['name'], 0)
				
		currentHistory -= 1

func last_instance_of(name):
	var lastPos
	for i in range(0, currentHistory - 1):
		if historyObj[i]['name'] == name:
			lastPos = i
	return lastPos

func connection_in_timeline(name):
	var graph = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph")
	var list = graph.get_connection_list()
	var connections = {}
	var conFrom = []
	
	for i in range(0, currentHistory - 1):
		if name == historyObj[i]['name']:
			connections = historyObj[i]['connects_from']

	for i in range(0, connections.size()):
		if connections.size() > 0:
			conFrom.append(connections[i+1])

	for i in range(0, list.size()):
		if graph.has_node(list[i]['to']) and not list[i]['from'] in conFrom:
			graph.disconnect_node(list[i]['from'], 0, name, 0)
	
	for i in range(0, currentHistory - 1):
		if historyObj[i]['connects_from']:
			for j in range(0, historyObj[i]['connects_from'].size()):
				if historyObj[i]['connects_from'][j+1] != name and historyObj[i]['name'] == name:
					graph.connect_node(historyObj[i]['connects_from'][j+1], 0, name, 0)

func redo_history():
	var graph = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph")
	if currentHistory < historyObj.size():
		# we're in the past
		var action = historyObj[currentHistory]['action']
		var obj = historyObj[currentHistory]
		
		if action == 'remove':
			graph.get_node(obj['name']).queue_free()
		if action == 'move':
			graph.get_node(obj['name']).set_offset(obj['offset'])
		if action == 'text':
			graph.get_node(obj['name']).get_node("Lines").get_child(0).set_text(obj['text'])
		if action == 'add':
			graph.load_node(obj['node']+'.tscn', obj['offset'], obj['name'], obj['text'])
		
		if 'connect' in action:
			if action == 'connect':
				for i in range(0, obj['connects_from'].size()):
					graph.connect_node(obj['connects_from'][i+1], 0, obj['name'], 0)
			else:
				print('disconnect node')
				var connections = graph.get_connection_list()
				for i in range(0, connections.size()):
					if connections[i].to == obj['name'] and not connections[i].from in obj['connects_from']:
						graph.disconnect_node(connections[i].from, 0, obj['name'], 0) 
		
		currentHistory += 1