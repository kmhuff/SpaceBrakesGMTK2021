extends Node2D


export (NodePath) var top_pos_path
export (NodePath) var bot_pos_path

var top_pos
var bot_pos

onready var timer = $Timer
onready var tween = $Tween


func _ready():
	top_pos = get_node(top_pos_path)
	bot_pos = get_node(bot_pos_path)
	global_position = top_pos.global_position


func _physics_process(_delta):
	if not tween.is_active() and timer.is_stopped():
		var goal_pos
		if global_position == top_pos.global_position:
			goal_pos = bot_pos
		else:
			goal_pos = top_pos
			
		tween.interpolate_property(self, "global_position", global_position, goal_pos.global_position, 2.0)
		tween.start()


func _on_Tween_tween_all_completed():
	timer.start()
