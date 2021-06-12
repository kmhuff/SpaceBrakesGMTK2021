extends Area2D


signal entered_goal


const GOAL_FORCE = 8000

onready var animation_player = $AnimationPlayer
onready var collision = $CollisionShape2D

var captured_ship = null


func _physics_process(_delta):
	if captured_ship:
		var distance = collision.global_position.distance_to(captured_ship.global_position)
		if distance > 50:
			captured_ship.set_goal_force(collision.global_position - captured_ship.global_position, 
					GOAL_FORCE / distance)
		else:
			captured_ship.set_goal_force(Vector2.ZERO, 0)


func _on_GoalArea_body_entered(body):
	animation_player.play("Touched")
	captured_ship = body
	emit_signal("entered_goal")
