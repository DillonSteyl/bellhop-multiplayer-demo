class_name RTCHostManager
extends RTCPeerManager

var _next_peer_id: int = 2


func _ready():
	super()
	peer.create_server()
	multiplayer.multiplayer_peer = peer


func add_connection(connection_id: String) -> RTCConnectionManager:
	var new_connection = _initialize_connection(connection_id, _next_peer_id)
	_next_peer_id += 1
	return new_connection
