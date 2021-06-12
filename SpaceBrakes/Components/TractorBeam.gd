extends Node2D


const BEAM_FORCE = 10000

export (NodePath) var ship1_path
export (NodePath) var ship2_path

onready var texture = $Sprite
onready var ship1 = get_node(ship1_path)
onready var ship2 = get_node(ship2_path)


func _process(_delta):
	if Input.is_action_pressed("tractor_beam"):
		var distance = ship1.global_position.distance_to(ship2.global_position)
		
		global_position = ship1.global_position
		texture.visible = true
		texture.rotation = ship1.global_position.angle_to_point(ship2.global_position) - (3 * PI/2)
		texture.region_rect.end.y = distance
		
		ship1.set_tractor_force(ship2.global_position - ship1.global_position, BEAM_FORCE / distance)
		ship2.set_tractor_force(ship1.global_position - ship2.global_position, BEAM_FORCE / distance)
	
	if Input.is_action_just_released("tractor_beam"):
		texture.visible = false
		
		ship1.set_tractor_force(Vector2.ZERO, 0)
		ship2.set_tractor_force(Vector2.ZERO, 0)
