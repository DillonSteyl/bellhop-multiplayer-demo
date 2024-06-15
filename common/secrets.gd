extends Node

@onready var _ws_secrets_json: JSON = load("res://secrets/websocket.json")
@onready var _ts_secrets_json: JSON = load("res://secrets/turn_servers.json")

@onready var websocket_url: String = _ws_secrets_json.data.WEBSOCKET_URL
@onready var turn_servers_config: Dictionary = _ts_secrets_json.data
