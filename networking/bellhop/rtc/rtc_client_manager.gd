class_name RTCClientManager
extends RTCPeerManager

var this_peer_id: int


func _ready():
	super()
	peer.create_client(this_peer_id)
	multiplayer.multiplayer_peer = peer


func add_connection(connection_id: String) -> RTCConnectionManager:
	var new_connection = _initialize_connection(connection_id, 1)
	new_connection.connection.create_offer()
	return new_connection
