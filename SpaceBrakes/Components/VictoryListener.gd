extends Node2D


const DialogWindow = preload("res://Components/DialogWindow.tscn")

export (PackedScene) var next_scene

var green_goal = false
var blue_goal = false
var window_created = false


func _process(_delta):
	if green_goal and blue_goal and not window_created:
		var window = DialogWindow.instance()
		window.title = "simulation success"
		if next_scene:
			window.text = "Proceed to the next simulation."
		else:
			window.text = "You have achieved victory."
		add_child(window)
		window.connect("tree_exiting", self, "_on_Window_exited")
		window_created = true


func _on_GreenGoal_entered_goal():
	green_goal = true


func _on_BlueGoal_entered_goal():
	blue_goal = true


func _on_Window_exited():
	if next_scene:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(next_scene)
	else:
		get_tree().quit()
