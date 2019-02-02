extends GridContainer

# Menus
onready var fileMenu = $File/Menu
onready var helpMenu = $Help/Menu
onready var editMenu = $Edit/Menu


#Dialog Windows
onready var saveDialog = get_node("../../../Modals/Save")
onready var openDialog = get_node("../../../Modals/Open")
onready var quitDialog = get_node("../../../Modals/QuitConf")
onready var aboutDialog = get_node("../../../Modals/About")
onready var newDialog = get_node("../../../Modals/New")
onready var importDialog = get_node("../../../Modals/Import")

func _on_File_pressed():
	if(fileMenu.is_visible()):
		fileMenu.hide()
	else:
		EditorSingleton.close_all()
		fileMenu.show()
		fileMenu.set_as_toplevel(true)

func _on_QuitConf_confirmed():
	get_tree().quit()

func _on_Help_pressed():
	if(helpMenu.is_visible()):
		helpMenu.hide()
	else:
		EditorSingleton.close_all()
		helpMenu.show()
		helpMenu.set_as_toplevel(true)

func _on_Edit_pressed():
	if(editMenu.is_visible()):
		editMenu.hide()
	else:
		EditorSingleton.close_all()
		editMenu.show()
		editMenu.set_as_toplevel(true)

func _on_About_pressed():
	EditorSingleton.close_all()
	aboutDialog.show()

func _on_Save_pressed():
	EditorSingleton.close_all()
	saveDialog.show()
	saveDialog.current_file = get_node("../../Editor/Info/Info/Name/Input").get_text()+'.json'

func _on_New_pressed():
	EditorSingleton.close_all()
	newDialog.show()

func _on_Open_pressed():
	EditorSingleton.close_all()
	openDialog.show()

func _on_Quit_pressed():
	EditorSingleton.close_all()
	quitDialog.show()

func _on_Import_pressed():
	EditorSingleton.close_all()
	importDialog.show()

func _on_menAct_mouse_entered():
	EditorSingleton.inMenu = true

func _on_menAct_mouse_exited():
	if(EditorSingleton.inMenu == true):
		EditorSingleton.inMenu = false

func _on_Update_pressed():
	EditorSingleton.update_demo()

func _on_Undo_pressed():
	EditorSingleton.close_all()
	EditorSingleton.undo_history()

func _on_Redo_pressed():
	EditorSingleton.close_all()
	EditorSingleton.redo_history()

func _on_source_pressed():
	OS.shell_open("https://github.com/littleMouseGames/whiskers")

