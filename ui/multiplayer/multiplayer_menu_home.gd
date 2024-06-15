class_name MultiplayerMenuHome
extends Control

@onready var start_lobby_button: Button = $%StartLobbyButton
@onready var join_lobby_button: Button = $%JoinLobbyButton
@onready var join_lobby_popup: Panel = $%JoinLobbyPopup
@onready var joining_status_popup: StatusPopup = $%JoiningLobbyStatusPopup


func _on_join_lobby_button_pressed():
	join_lobby_popup.visible = true


func _on_join_lobby_popup_requested_to_join(_lobby_id):
	joining_status_popup.show_popup()
