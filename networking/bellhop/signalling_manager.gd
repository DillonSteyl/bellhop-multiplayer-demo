class_name SignallingManager
extends Node
## The SignallingManager is responsible for managing the WebSocket connection to the BELLHOP signalling API.
## It can send actions, and emits signals when events are received.

signal connection_state_changed(new_state: WebSocketPeer.State)
signal websocket_opened
signal websocket_closed
signal pushed_info_message(message: String)

signal lobby_started(event: BellhopLobbyStarted)
signal received_join_request(event: BellhopReceivedJoinRequest)
signal join_request_accepted(event: BellhopJoinRequestAccepted)
signal join_request_rejected(event: BellhopJoinRequestRejected)
signal received_ice_candidate(event: BellhopReceivedIceCandidate)
signal received_session_description(event: BellhopReceivedSessionDescription)

var _ws_peer = WebSocketPeer.new()
var _ws_peer_state = null:
	set = _set_ws_peer_state


func _ready():
	_ws_peer.connect_to_url(Secrets.websocket_url)
	connection_state_changed.connect(_on_connection_state_changed)


func _process(_delta):
	_ws_peer.poll()
	_ws_peer_state = _ws_peer.get_ready_state()

	if _ws_peer.get_available_packet_count() > 0:
		var packet = _ws_peer.get_packet()
		var event = _get_bellhop_event(packet)
		if event == null:
			return
		_handle_bellhop_event(event)


func start_lobby():
	_ws_peer.send_text(BellhopActionMessages.start_lobby())


func accept_join_request(connection_id: String, peer_id: int):
	_ws_peer.send_text(BellhopActionMessages.accept_join_request(connection_id, peer_id))


func join_lobby(lobby_id: String):
	_ws_peer.send_text(BellhopActionMessages.join_lobby(lobby_id))


func _handle_bellhop_event(event: BellhopEvent):
	if event is BellhopLobbyStarted:
		pushed_info_message.emit("Lobby started! id: " + event.lobby_id)
		lobby_started.emit(event)
		return
	if event is BellhopReceivedJoinRequest:
		pushed_info_message.emit(
			"Received join request from: {id}. Accepting...".format({"id": event.connection_id})
		)
		received_join_request.emit(event)
		return
	if event is BellhopJoinRequestAccepted:
		pushed_info_message.emit("Join request accepted! Host ID is " + event.host_connection_id)
		join_request_accepted.emit(event)
		return
	if event is BellhopJoinRequestRejected:
		pushed_info_message.emit("Join request rejected.")
		join_request_rejected.emit(event)
		return
	if event is BellhopReceivedIceCandidate:
		received_ice_candidate.emit(event)
		return
	if event is BellhopReceivedSessionDescription:
		received_session_description.emit(event)
		return


func _get_bellhop_event(packet: PackedByteArray) -> BellhopEvent:
	var json = JSON.new()
	var err = json.parse(packet.get_string_from_utf8())
	if err != OK:
		push_error("Failed to parse JSON packet: %s" % [err])
		return

	var event = json.data.get("event")
	var content = json.data.get("content")
	if not event:
		var packet_data = json.data
		push_error(
			"Received packet without event field: {packet_data}".format(
				{"packet_data": packet_data}
			)
		)
		return

	var bellhop_event = BellhopEvent.create(event, content)
	print("Received event: {bellhop_event}".format({"bellhop_event": bellhop_event}))
	return bellhop_event


func _set_ws_peer_state(new_state: WebSocketPeer.State):
	var did_change = new_state != _ws_peer_state
	_ws_peer_state = new_state
	if did_change:
		connection_state_changed.emit(new_state)


func _on_connection_state_changed(new_state: WebSocketPeer.State):
	match new_state:
		WebSocketPeer.STATE_CONNECTING:
			print("Connecting to websocket server...")
		WebSocketPeer.STATE_OPEN:
			websocket_opened.emit()
			print("Websocket is open!")
		WebSocketPeer.STATE_CLOSING:
			print("Connection to websocket server closing...")
		WebSocketPeer.STATE_CLOSED:
			websocket_closed.emit()
			print(
				"Connection to websocket server closed with code {close_code}".format(
					{"close_code": _ws_peer.get_close_code()}
				)
			)


func _exit_tree():
	_ws_peer.close()
