extends Node

signal player_connected(peer_id: int, player_info: PlayerInfo)

var player_info = PlayerInfo.new()
var players_by_id = {}


func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(
		func(): _add_player(multiplayer.get_unique_id(), player_info)
	)


func update_player_name(new_name: String):
	player_info.player_name = new_name


@rpc("any_peer", "reliable")
func register_player(pi_json: Dictionary):
	var new_peer_id = multiplayer.get_remote_sender_id()
	var new_player_info = PlayerInfo.from_json(pi_json)
	_add_player(new_peer_id, new_player_info)


func _add_player(peer_id: int, new_player_info: PlayerInfo) -> void:
	players_by_id[peer_id] = new_player_info
	print(
		"Adding new player {id}={name}".format({"id": peer_id, "name": new_player_info.player_name})
	)
	player_connected.emit(peer_id, new_player_info)


## When a peer connects, send them my player info
func _on_peer_connected(id: int):
	register_player.rpc_id(id, player_info.as_json())
