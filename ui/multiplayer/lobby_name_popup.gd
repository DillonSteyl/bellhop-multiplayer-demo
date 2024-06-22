class_name LobbyNamePopup
extends Panel

const VALID_CHARACTERS_REGEX = "[A-Za-z0-9-]"

signal submitted_lobby_name(lobby_name: String)

@onready var title: Label = $%Title
@onready var submit_button: Button = $%SubmitButton
@onready var lobby_id_line_edit: LineEdit = $%LobbyIDLineEdit


func _on_close_button_pressed():
	visible = false


func _on_submit_button_pressed():
	submitted_lobby_name.emit(lobby_id_line_edit.text)


func _on_lobby_id_line_edit_text_changed(new_text: String):
	var old_caret_column = lobby_id_line_edit.caret_column

	var valid_text = ""
	var regex = RegEx.new()
	regex.compile(VALID_CHARACTERS_REGEX)
	for valid_character in regex.search_all(new_text):
		valid_text += valid_character.get_string()
	lobby_id_line_edit.text = valid_text.to_lower()
	lobby_id_line_edit.caret_column = old_caret_column
