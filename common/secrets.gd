extends Node

@onready var _ws_secrets_json: JSON = load("res://secrets/websocket.json")
@onready var websocket_url: String = _ws_secrets_json.data.WEBSOCKET_URL
