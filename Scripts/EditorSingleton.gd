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
		print(tempHistory)

func add_history(node, name, offset, text, connects_to, connects_from):
	overwrite_history()
	historyObj[currentHistory] = {
			'node': node,
			'name': name,
			'offset': offset,
			'text': text,
			'connects_to': connects_to,
			'connects_from': connects_from
	}
	currentHistory += 1

func undo_history():
	if currentHistory > 1:
		var graph = get_node("/root/Editor/Mount/MainWindow/Editor/Graph/Dialogue Graph")
		var node = historyObj[currentHistory - 1]
		var hasNode = graph.has_node(node['name'])
		print(currentHistory, ":", historyObj.size())
		# are we undoing a remove?
	
		if !hasNode:
			graph.load_node(node['node']+'.tscn', node['offset'], node['name'], node['text'])
		if hasNode:
			var prevNode = historyObj[currentHistory - 2]
			var graphNode = graph.get_node(prevNode['name'])
			graphNode.set_offset(prevNode['offset'])
			if graphNode.has_node('Lines'):
				graphNode.get_node('Lines').get_child(0).set_text(prevNode['text'])
	
		currentHistory -= 1