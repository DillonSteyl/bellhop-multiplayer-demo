class_name NotificationPopup
extends Control

@export var text: String:
	set = _set_text

@onready var confirm_button: Button = $ConfirmButton
@onready var label: Label = $NotificationLabel


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


func _on_confirm_button_pressed() -> void:
	hide_popup()
