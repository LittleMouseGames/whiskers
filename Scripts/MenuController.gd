extends GridContainer

# Menus
var fileMenu
var helpMenu

#Dialog Windows
var saveDialog
var openDialog
var quitDialog
var aboutDialog
var newDialog
var importDialog

func _ready():
	fileMenu = get_node("File/Menu")
	helpMenu = get_node("Help/Menu")
	saveDialog = get_node("../../../Modals/Save")
	openDialog = get_node("../../../Modals/Open")
	quitDialog = get_node("../../../Modals/QuitConf")
	aboutDialog = get_node("../../../Modals/About")
	newDialog = get_node("../../../Modals/New")
	importDialog = get_node("../../../Modals/Import")

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

