class_name MultiplayerMenuHome
extends Control

@onready var start_lobby_button: Button = $%StartLobbyButton
@onready var join_lobby_button: Button = $%JoinLobbyButton
@onready var join_lobby_popup: LobbyNamePopup = $%JoinLobbyPopup
@onready var start_lobby_popup: LobbyNamePopup = $%StartLobbyPopup
@onready var joining_status_popup: StatusPopup = $%JoiningLobbyStatusPopup


func _on_join_lobby_button_pressed():
	join_lobby_popup.visible = true


func _on_start_lobby_button_pressed():
	start_lobby_popup.visible = true


func _on_join_lobby_popup_submitted_lobby_name(_lobby_name: String) -> void:
	joining_status_popup.show_popup()
