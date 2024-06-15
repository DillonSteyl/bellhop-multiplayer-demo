class_name LobbyUI
extends Control

const LOBBY_MESSAGE_LABEL_SCENE: PackedScene = preload(
	"res://ui/multiplayer/lobby/lobby_message_label.tscn"
)

@onready var back_button: Button = $%BackButton
@onready var messages_vbox: VBoxContainer = $%MessagesVBox
@onready var messages_scroll_container: ScrollContainer = $%MessagesScrollContainer
@onready var status_popup: StatusPopup = $%StatusPopup
@onready var message_line_edit: LineEdit = $%MessageLineEdit


func _ready():
	messages_scroll_container.get_v_scroll_bar().changed.connect(_scroll_to_bottom)


func set_loading(status_text: String):
	status_popup.text = status_text
	status_popup.show_popup()


func add_message(text: String):
	var message_label: RichTextLabel = LOBBY_MESSAGE_LABEL_SCENE.instantiate()
	messages_vbox.add_child(message_label)
	message_label.text = text


@rpc("any_peer", "call_local", "reliable")
func add_chat_message(message: String):
	add_message(message)


func _on_lobby_started(_event: BellhopLobbyStarted):
	status_popup.hide_popup()


func _on_send_message():
	add_chat_message.rpc(
		"{pid} says: {text}".format(
			{"pid": multiplayer.get_unique_id(), "text": message_line_edit.text}
		)
	)
	message_line_edit.clear()


func _on_message_line_edit_text_submitted(_new_text: String):
	_on_send_message()


func _scroll_to_bottom():
	var v_scroll_bar = messages_scroll_container.get_v_scroll_bar()
	v_scroll_bar.set_deferred("value", v_scroll_bar.max_value)
