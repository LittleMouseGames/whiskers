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

func _input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				if(!inMenu):
					get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/File/Menu").hide()
					get_node("/root/Editor/Mount/MainWindow/MenuBar/Menus/Help/Menu").hide()

func update_demo():
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
	print(historyObj, '\n\n')

func undo_history():
	print(currentHistory, ":", historyObj.size())
	var graph = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph")
	if currentHistory > 1:
		var node = historyObj[currentHistory - 1]
		var hasNode = graph.has_node(node['name'])
		# are we undoing a remove?
		if !hasNode:
			graph.load_node(node['node']+'.tscn', node['offset'], node['name'], node['text'])
		if hasNode:
			var prevNode = historyObj[currentHistory - 2]
			var graphNode = graph.get_node(prevNode['name'])
			if graphNode:
				graphNode.set_offset(prevNode['offset'])
				if graphNode.has_node('Lines'):
					graphNode.get_node('Lines').get_child(0).set_text(prevNode['text'])
				
				for i in range(0, node['connects_from'].size()):
					graph.connect_node(node['connects_from'][i+1], 0, node['name'], 0)
				
				connection_in_timeline(node['name'])
				
	if currentHistory > 0:
		for i in range(0, graph.get_child_count()):
			if get_node_type(graph.get_child(i).name) in EditorSingleton.nodeNames:
				if !node_in_timeline(graph.get_child(i).get_name()):
					graph.get_child(i).queue_free()
		
		currentHistory -= 1

func node_in_timeline(name):
	if get_node_type(name) in EditorSingleton.nodeNames:
		var existsInTimeline = false
		for z in range(0, currentHistory - 1):
			if name in historyObj[z]['name']:
				return true

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