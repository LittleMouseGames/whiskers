extends GraphEdit

var lastNodePosition = Vector2(0,0)

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

#=======> SAVING
var data = {} # this is the final data, an array of all nodes that we write to file
func _processData(connectionList):
	for i in range(0, connectionList.size()):
		var name = connectionList[i].from
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
		
		if(currentConnectsTo):
			tempData['connects_to'] = currentConnectsTo
		if not(connectionList[i].to in tempData['connects_to'].values()):
			tempData['connects_to'][currentCTSize+1] = connectionList[i].to
		
		# store our location
		tempData['location'] = self.get_node(name).get_offset()
		
		# save this in our processed object
		data[name] = tempData

func _on_Save_confirmed():
	var connectionList = get_connection_list()
	_processData(connectionList)
	# write the file
	print(data)
	# clear our data node
	data = {}