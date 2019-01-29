extends Node

var inMenu = false
var test = true

var loadedPlayerVars = false
var loadedPlayerFuncs = false
var hasPlayerSingleton = false

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