extends GraphEdit

var lastNodePosition = Vector2(0,0)

func _ready():
	get_node("../../../../Modals/Save").connect("file_selected", self, "_save_whiskers")
	get_node("../../../../Modals/Open").connect("file_selected", self, "_open_whiskers")

func _on_Dialogue_Graph_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)

func _on_Dialogue_Graph_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)

func _initScene(e):
	var scene = load("res://Scenes/Nodes/"+e)
	var node = scene.instance()
	get_node("./").add_child(node)
	node.set_offset(Vector2(lastNodePosition.x + 20, lastNodePosition.y + 20))
	node.set_name(node.get_name().replace('@', ''))
	lastNodePosition = node.get_offset()

func _load_node(type, location, name, text):
	var scene = load("res://Scenes/Nodes/"+type)
	var node = scene.instance()
	get_node("./").add_child(node)
	location = str(location).replace('(','').replace(')','').split(',')
	node.set_offset(Vector2(location[0], location[1]))
	node.set_name(name)
	if(text):
		node.get_node('Lines').get_child(0).set_text(text)

func _on_BasicNodes_item_activated(index):
	if(index == 0):
		_initScene("Dialogue.tscn")
	if(index == 1):
		_initScene("Option.tscn")
	if(index == 2):
		_initScene("Jump.tscn")

func _on_AdvancedNodes_item_activated(index):
	if(index == 0):
		_initScene("Condition.tscn")
	if(index == 1):
		_initScene("Expression.tscn")

func _on_UtilityNodes_item_activated(index):
	if(index == 0):
		_initScene("Start.tscn")
	if(index == 1):
		_initScene("End.tscn")

#=======> SAVING
var data = {} # this is the final data, an array of all nodes that we write to file
func _processData(connectionList):
	for i in range(0, connectionList.size()):
		var name = connectionList[i].from
		# Our schema
		var tempData = {
			'text':"",
			'connects_to':{},
			'logic':"",
			'conditions':{},
			'location':""
		}
		var currentCTSize = 0
		var currentConnectsTo 
		if(name in data):
			currentCTSize = data[name]['connects_to'].size()
			currentConnectsTo = data[name]['connects_to']
		
		# are we a node with a text field?
		if('Dialogue' in name) or ('Option' in name) or ('Expression' in name) or ('Jump' in name):
			tempData['text'] = self.get_node(name).get_node('Lines').get_child(0).get_text()
		
		# are we an Expression Node? We should store the value in our logic field
		if('Expression' in name):
			tempData['logic'] = self.get_node(name).get_node('Lines').get_child(0).get_text()
		
		if(currentConnectsTo):
			tempData['connects_to'] = currentConnectsTo
		if not(connectionList[i].to in tempData['connects_to'].values()):
			tempData['connects_to'][currentCTSize+1] = connectionList[i].to
		
		# store our location
		tempData['location'] = self.get_node(name).get_offset()
		
		# save this in our processed object
		data[name] = tempData

func _save_whiskers(path):
	if(path):
		var connectionList = get_connection_list()
		_processData(connectionList)
		# write the file
		print('saving file to: ', path)
		var saveFile = File.new()
		saveFile.open(path, File.WRITE)
		saveFile.store_line(to_json(data))
		saveFile.close()
		print(data)
		# clear our data node
		data = {}

#======> Open file
func _open_whiskers(path):
	if(path):
		print('opening file: ', path)
		var file = File.new()
		file.open(path, File.READ)
		var loadData = parse_json(file.get_as_text())
		var nodeDataKeys = loadData.keys()
		for i in range(0, nodeDataKeys.size()):
			var type
			var node = loadData[nodeDataKeys[i]]
			if('Dialogue' in nodeDataKeys[i]):
				type = 'Dialogue.tscn'
			if('Option' in nodeDataKeys[i]):
				type = 'Option.tscn'
			if('Expression' in nodeDataKeys[i]):
				type = 'Expression.tscn'
			if('Condition' in nodeDataKeys[i]):
				type = 'Condition.tscn'
			if('Jump' in nodeDataKeys[i]):
				type = 'Jump.tscn'
			if('End' in nodeDataKeys[i]):
				type = 'End.tscn'
			if('Start' in nodeDataKeys[i]):
				type = 'Start.tscn'
			_load_node(type, node['location'], nodeDataKeys[i], node['text'])
		
		#everything has been loaded and added to the graph, lets connect them all!
		for i in range(0, nodeDataKeys.size()):
			var connectTo = loadData[nodeDataKeys[i]]['connects_to']
			# for each key
			for x in range(1, connectTo.size()+1):
				connect_node(nodeDataKeys[i], 0, connectTo[str(x)], 0)
