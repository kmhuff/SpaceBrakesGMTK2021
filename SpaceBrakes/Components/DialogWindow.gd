extends CanvasLayer


export var title = "title goes here"
export var text = "Lorem Ipsum"

onready var title_label = $MarginContainer/VBoxContainer/Title
onready var text_label = $MarginContainer/VBoxContainer/Text


func _ready():
	title_label.text = title
	text_label.text = text


func _process(_delta):
	if Input.is_action_pressed("tractor_beam"):
		queue_free()
