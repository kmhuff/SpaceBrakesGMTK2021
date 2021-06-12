extends RigidBody2D


const BRAKE_MAG = 10

export var initial_angle_deg = 0
export var initial_speed = 200
export (Texture) var ship_texture
export var brake_input = "green_space_brakes"

var tractor_force_direction = Vector2.ZERO
var tractor_force_magnitude = 0

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
		shield_sprite.visible = true
		mass = mass * BRAKE_MAG
		state.linear_velocity = state.linear_velocity / sqrt(BRAKE_MAG)
	
	applied_force = Vector2(tractor_force_magnitude * tractor_force_direction.x, 
			tractor_force_magnitude * tractor_force_direction.y)
	
	if Input.is_action_just_released(brake_input):
		shield_sprite.visible = false
		mass = mass / BRAKE_MAG
		state.linear_velocity = state.linear_velocity * sqrt(BRAKE_MAG)


func _on_Ship_body_entered(_body):
	print('Hit!')
	get_tree().reload_current_scene()


func set_tractor_force(direction, magnitude):
	tractor_force_direction = direction.normalized()
	tractor_force_magnitude = magnitude
