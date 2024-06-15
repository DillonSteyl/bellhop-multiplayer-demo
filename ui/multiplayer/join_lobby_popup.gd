extends Panel

const VALID_CHARACTERS_REGEX = "[A-Za-z0-9-]"
const UUID4_REGEX = "[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}"

signal requested_to_join(lobby_id: String)

@onready var join_button: Button = $%JoinButton
@onready var lobby_id_line_edit: LineEdit = $%LobbyIDLineEdit


func _on_close_button_pressed():
	visible = false


func _on_join_button_pressed():
	requested_to_join.emit(lobby_id_line_edit.text)


func _on_lobby_id_line_edit_text_changed(new_text: String):
	var old_caret_column = lobby_id_line_edit.caret_column

	var valid_text = ""
	var regex = RegEx.new()
	regex.compile(VALID_CHARACTERS_REGEX)
	for valid_character in regex.search_all(new_text):
		valid_text += valid_character.get_string()
	lobby_id_line_edit.text = valid_text.to_lower()
	lobby_id_line_edit.caret_column = old_caret_column

	var uuid_regex = RegEx.new()
	uuid_regex.compile(UUID4_REGEX)
	join_button.disabled = (uuid_regex.search(new_text) == null)
