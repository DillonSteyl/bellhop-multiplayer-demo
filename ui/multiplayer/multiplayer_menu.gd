extends Control

const BASE_MENU_SCENE: PackedScene = preload("res://ui/multiplayer/multiplayer_menu_base.tscn")
const LOBBY_UI_SCENE: PackedScene = preload("res://ui/multiplayer/lobby/lobby_ui.tscn")

@export var signalling_manager: SignallingManager

@onready var active_ui: Control = $%ActiveUI
@onready var connecting_popup: StatusPopup = $%ConnectingPopup


func _ready():
	_go_to_base()
	connecting_popup.show_popup()
	signalling_manager.websocket_opened.connect(connecting_popup.hide_popup)


func _go_to_base():
	_clear_active_ui()
	var ui: MultiplayerMenuBase = BASE_MENU_SCENE.instantiate()
	active_ui.add_child(ui)
	ui.start_lobby_button.pressed.connect(_start_lobby)


func _start_lobby():
	var lobby_ui = _go_to_lobby()
	signalling_manager.start_lobby()

	lobby_ui.initialize("Creating lobby...")
	signalling_manager.lobby_started.connect(lobby_ui._on_lobby_started)
	signalling_manager.pushed_info_message.connect(lobby_ui.add_message)


func _go_to_lobby() -> LobbyUI:
	_clear_active_ui()
	var ui: LobbyUI = LOBBY_UI_SCENE.instantiate()
	active_ui.add_child(ui)
	ui.back_button.pressed.connect(_go_to_base)
	return ui


func _clear_active_ui():
	for child in active_ui.get_children():
		child.queue_free()
