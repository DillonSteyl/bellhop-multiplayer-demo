class_name StatusPopup
extends Control

@export var text: String:
	set = _set_text

@onready var label: Label = $StatusLabel


func _ready():
	label.text = text


func show_popup():
	visible = true


func hide_popup():
	visible = false


func _set_text(value: String):
	text = value
	if label:
		label.text = value
