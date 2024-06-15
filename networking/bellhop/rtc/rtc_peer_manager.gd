class_name RTCPeerManager
extends Node

@export var signalling_manager: SignallingManager

var peer = WebRTCMultiplayerPeer.new()


func _ready():
	return


## Virtual function - call to connect to another peer
func add_connection(_connection_id: String) -> RTCConnectionManager:
	return


# Creates a new RTC connection manager
func _initialize_connection(connection_id: String, peer_id: int) -> RTCConnectionManager:
	var connection_manager = RTCConnectionManager.new()
	connection_manager.signalling_manager = signalling_manager
	connection_manager.destination_connection_id = connection_id
	connection_manager.destination_peer_id = peer_id
	_setup_connection_manager_signals(connection_manager)
	add_child(connection_manager)
	peer.add_peer(connection_manager.connection, peer_id)
	return connection_manager


func _setup_connection_manager_signals(connection_manager: RTCConnectionManager) -> void:
	signalling_manager.received_ice_candidate.connect(connection_manager._on_received_ice_candidate)
	signalling_manager.received_session_description.connect(
		connection_manager._on_received_session_description
	)


func _exit_tree():
	multiplayer.multiplayer_peer.close()
