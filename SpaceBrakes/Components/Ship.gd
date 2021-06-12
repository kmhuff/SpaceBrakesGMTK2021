extends RigidBody2D


const BRAKE_MAG = 10

export var initial_angle_deg = 0
export var initial_speed = 200
export (Texture) var ship_texture
export var brake_input = "green_space_brakes"

var tractor_force_direction = Vector2.ZERO
var tractor_force_magnitude = 0

var braking = false
var in_goal = false

onready var sprite = $Sprite
onready var shield_sprite = $ShieldSprite


func _ready():
	linear_velocity = Vector2(initial_speed * cos(deg2rad(initial_angle_deg)), 
			initial_speed * sin(deg2rad(initial_angle_deg)))
	
	sprite.texture = ship_texture
	sprite.rotation = linear_velocity.angle() + (PI/2)


func _process(_delta):
	sprite.rotation = linear_velocity.angle() + (PI/2)


func _integrate_forces(state):
	if Input.is_action_just_pressed(brake_input):
		$BrakeSound.play()
		shield_sprite.visible = true
		mass = mass * BRAKE_MAG
		state.linear_velocity = state.linear_velocity / sqrt(BRAKE_MAG)
		braking = true
	
	applied_force = Vector2(tractor_force_magnitude * tractor_force_direction.x, 
			tractor_force_magnitude * tractor_force_direction.y)
	
	if in_goal:
		linear_damp = 2
	
	if Input.is_action_just_released(brake_input) and braking:
		shield_sprite.visible = false
		mass = mass / BRAKE_MAG
		state.linear_velocity = state.linear_velocity * sqrt(BRAKE_MAG)
		braking = false


func _on_Ship_body_entered(_body):
	$DeathSound.play()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().reload_current_scene()


func set_tractor_force(direction, magnitude):
	if not in_goal:
		tractor_force_direction = direction.normalized()
		tractor_force_magnitude = magnitude


func set_goal_force(direction, magnitude):
	tractor_force_direction = direction.normalized()
	tractor_force_magnitude = magnitude
	if not in_goal:
		in_goal = true
