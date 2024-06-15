extends Node

@onready var signalling_manager: SignallingManager = $%SignallingManager
@onready var multiplayer_menu: MultiplayerMenu = $%MultiplayerMenu

var rtc_peer_manager: RTCPeerManager


func _on_signalling_manager_lobby_started(_event: BellhopLobbyStarted):
	_remove_rtc_peer_manager()
	rtc_peer_manager = RTCHostManager.new()
	rtc_peer_manager.signalling_manager = signalling_manager
	add_child(rtc_peer_manager)


func _on_signalling_manager_join_request_accepted(event: BellhopJoinRequestAccepted):
	_remove_rtc_peer_manager()
	rtc_peer_manager = RTCClientManager.new()
	rtc_peer_manager.signalling_manager = signalling_manager
	rtc_peer_manager.this_peer_id = event.peer_id
	add_child(rtc_peer_manager)

	rtc_peer_manager.add_connection(event.host_connection_id)

	multiplayer.connected_to_server.connect(multiplayer_menu.go_to_lobby)
	multiplayer.server_disconnected.connect(multiplayer_menu.go_to_home)


func _on_signalling_manager_received_join_request(event: BellhopReceivedJoinRequest):
	if not rtc_peer_manager is RTCHostManager:
		push_error("Received join request without an active RTC host manager")
		return

	var new_connection = rtc_peer_manager.add_connection(event.connection_id)
	signalling_manager.accept_join_request(event.connection_id, new_connection.destination_peer_id)


func _on_signalling_manager_lobby_closed():
	_remove_rtc_peer_manager()


func _remove_rtc_peer_manager():
	if rtc_peer_manager and is_instance_valid(rtc_peer_manager):
		rtc_peer_manager.queue_free()
