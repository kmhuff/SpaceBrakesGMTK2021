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
var input_enabled = false
var dying = false
var winning = false

onready var sprite = $Sprite
onready var shield_sprite = $ShieldSprite


func _ready():
	sprite.texture = ship_texture
	sprite.rotation_degrees = initial_angle_deg + 90


func _process(_delta):
	if linear_velocity != Vector2.ZERO:
		sprite.rotation = linear_velocity.angle() + (PI/2)


func _integrate_forces(state):
	if Input.is_action_just_pressed(brake_input) and input_enabled:
		$BrakeSound.play()
		shield_sprite.visible = true
		mass = mass * BRAKE_MAG
		state.linear_velocity = state.linear_velocity / BRAKE_MAG
		braking = true
	
	applied_force = Vector2(tractor_force_magnitude * tractor_force_direction.x, 
			tractor_force_magnitude * tractor_force_direction.y)
	
	if in_goal:
		linear_damp = 2
	
	if Input.is_action_just_released(brake_input) and braking and input_enabled:
		shield_sprite.visible = false
		mass = mass / BRAKE_MAG
		state.linear_velocity = state.linear_velocity * BRAKE_MAG
		braking = false


func _on_Ship_body_entered(_body):
	if not winning:
		$DeathSound.play()
		dying = true
		yield(get_tree().create_timer(2.0), "timeout")
# warning-ignore:return_value_discarded
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


func enable_input():
	input_enabled = true
	apply_central_impulse(Vector2(initial_speed * cos(deg2rad(initial_angle_deg)), 
			initial_speed * sin(deg2rad(initial_angle_deg))))


func win():
	winning = true
