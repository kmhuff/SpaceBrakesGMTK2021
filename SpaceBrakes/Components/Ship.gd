extends RigidBody2D


export var initial_angle_deg = 0
export var initial_speed = 200
export (Texture) var ship_texture

onready var sprite = $Sprite


func _ready():
	linear_velocity = Vector2(initial_speed * cos(deg2rad(initial_angle_deg)), 
			initial_speed * sin(deg2rad(initial_angle_deg)))
	
	sprite.texture = ship_texture
	sprite.rotation = linear_velocity.angle() + (PI/2)


func _process(_delta):
	sprite.rotation = linear_velocity.angle() + (PI/2)
