class_name LobbyUI
extends Control

const LOBBY_MESSAGE_LABEL_SCENE: PackedScene = preload(
	"res://ui/multiplayer/lobby/lobby_message_label.tscn"
)

@onready var back_button: Button = $%BackButton
@onready var messages_vbox: VBoxContainer = $%MessagesVBox
@onready var status_popup: StatusPopup = $%StatusPopup


func initialize(status_text: String):
	status_popup.text = status_text
	status_popup.show_popup()


func add_message(text: String):
	var message_label: RichTextLabel = LOBBY_MESSAGE_LABEL_SCENE.instantiate()
	messages_vbox.add_child(message_label)
	message_label.text = text


func _on_lobby_started(_event: BellhopLobbyStarted):
	status_popup.hide_popup()
