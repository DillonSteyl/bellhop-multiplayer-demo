class_name MultiplayerMenu
extends Control

const HOME_MENU_SCENE: PackedScene = preload("res://ui/multiplayer/multiplayer_menu_home.tscn")
const LOBBY_UI_SCENE: PackedScene = preload("res://ui/multiplayer/lobby/lobby_ui.tscn")

@export var signalling_manager: SignallingManager

@onready var active_ui: Control = $%ActiveUI
@onready var connecting_popup: StatusPopup = $%ConnectingPopup


func _ready():
	go_to_home()
	connecting_popup.show_popup()
	signalling_manager.websocket_opened.connect(connecting_popup.hide_popup)


func go_to_home():
	signalling_manager.close_lobby()
	_clear_active_ui()
	var ui: MultiplayerMenuHome = HOME_MENU_SCENE.instantiate()
	active_ui.add_child(ui)
	ui.start_lobby_popup.submitted_lobby_name.connect(_start_lobby)
	ui.join_lobby_popup.submitted_lobby_name.connect(signalling_manager.join_lobby)


func go_to_lobby() -> LobbyUI:
	_clear_active_ui()
	var ui: LobbyUI = LOBBY_UI_SCENE.instantiate()
	active_ui.add_child(ui, true)
	ui.name = "LobbyUI"
	ui.back_button.pressed.connect(go_to_home)
	ui.failed_notification_popup.confirm_button.pressed.connect(go_to_home)
	return ui


func _start_lobby(lobby_id: String):
	var lobby_ui = go_to_lobby()
	signalling_manager.start_lobby(lobby_id)

	lobby_ui.set_loading("Creating lobby...")
	signalling_manager.lobby_started.connect(lobby_ui._on_lobby_started)
	signalling_manager.lobby_creation_failed.connect(lobby_ui._on_lobby_creation_failed)
	signalling_manager.pushed_info_message.connect(lobby_ui.add_message)


func _clear_active_ui():
	for child in active_ui.get_children():
		child.queue_free()
