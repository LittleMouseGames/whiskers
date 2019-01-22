extends Node

var inMenu = false

func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("save"):
			_close_all()
			get_node("/root/Editor/Mount/Modals/Save").show()
		if Input.is_action_pressed("open"):
			_close_all()
			get_node("/root/Editor/Mount/Modals/Open").show()
		if Input.is_action_pressed("quit"):
			_close_all()
			get_node("/root/Editor/Mount/Modals/QuitConf").show()
		if Input.is_action_pressed("help"):
			_close_all()
			get_node("/root/Editor/Mount/Modals/About").show()
		if Input.is_action_pressed("new"):
			_close_all()
			get_node("/root/Editor/Mount/Modals/New").show()

func _close_all():
	# modals
	get_node("/root/Editor/Mount/Modals/Save").hide()
	get_node("/root/Editor/Mount/Modals/Open").hide()
	get_node("/root/Editor/Mount/Modals/QuitConf").hide()
	get_node("/root/Editor/Mount/Modals/About").hide()
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