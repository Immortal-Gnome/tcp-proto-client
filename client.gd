class_name Client
extends Node

var status: int = 0
var peer: StreamPeerTCP = null
@onready var timeout_timer: Timer = Timer.new()

const proto = preload("res://proto/data.proto.gd")

var timeout: bool = false

signal update_grid(data : proto.Grid_Data)

func _ready() -> void:
	timeout_timer.autostart = false
	timeout_timer.one_shot = true
	timeout_timer.wait_time = 5.0
	add_child(timeout_timer)
	#timeout_timer.timeout.connect(_on_connection_timeout)


func _process(delta: float) -> void:
	if !peer: return
	
	if peer.get_status() != StreamPeerTCP.STATUS_CONNECTED: return
	peer.poll()
	
	if peer.get_available_bytes() == 0: return
	
	var length = peer.get_available_bytes()
	var bytes = peer.get_data(length)
	if bytes[0] != OK:
		print("ERROR on receive")
	bytes = bytes[1]
	print("bytes: ", bytes)
	var data = proto.Grid_Data.new()
	var res = data.from_bytes(bytes)
	if res != proto.PB_ERR.NO_ERRORS:
		print("ERROR could not deserialize")
	print("NO ERROR")
	#print("Printing Tilemap")
	update_grid.emit(data)
	#for tile in data.get_tiles():
		#print("tile: " + tile.to_string())



func connect_client(host: String, port:int) -> String:
	print("Connecting to %s:%d" % [host, port])
	peer = StreamPeerTCP.new()
	if peer.connect_to_host(host, port) != OK:
		print("ERROR connecting to host.")
		disconnect_client()
		return ""
	
	print("INFO connected to ", peer.get_connected_host(), ':', peer.get_connected_port())
	print("INFO port ", peer.get_local_port())
	timeout_timer.start()
	while (peer.get_status() == StreamPeerTCP.STATUS_CONNECTING):
		if timeout:
			print("ERROR timeout")
			disconnect_client()
			return ""
		await get_tree().create_timer(0.1).timeout
		peer.poll()
		if peer.get_status() == StreamPeerTCP.STATUS_ERROR:
			print("ERROR CONNECTING!!!")
			disconnect_client()
			return "FUCK"
		elif peer.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			return "Connected Successfully"
	return "DUNNO WHAT HAPPENED"
	
func disconnect_client() -> bool:
	peer.disconnect_from_host()
	peer = null
	print("DISCONNECTED FROM SERVER")
	print("________________________")
	return true

func send_message(msg:int):
	#print("1 :" + str(var_to_bytes(1)))
	#print("2 :" + str(var_to_bytes(1)))
	#print("bytes:" + str(var_to_bytes(msg)))
	peer.put_32(msg)
	
	#peer.put_data(var_to_bytes(msg))
	pass





#func connect_to_host(host: String, port: int) -> String:
	#print("Connecting to %s:%d" % [host, port])
	#stream = StreamPeerTCP.new()
#
	#if stream.connect_to_host(host, port) != OK:
		#print("ERROR connecting to host.")
		#reset_stream()
		#return ""
		#
	#print("INFO connected to ", stream.get_connected_host(), ':', stream.get_connected_port())
	#print("INFO port ", stream.get_local_port())
	#
	#timeout_timer.start()
	#while (stream.get_status() == StreamPeerTCP.STATUS_CONNECTING):
		#if timeout:
			#print("ERROR timeout")
			#reset_stream()
			#return ""
		#await get_tree().create_timer(0.1).timeout
		#stream.poll()
	#
	#if stream.get_status() == StreamPeerTCP.STATUS_ERROR:
		#print("ERROR CONNECTING!!!")
		#reset_stream()
		#return "FUCK"
	#
	#var length = stream.get_available_bytes()
	#var bytes = stream.get_data(length)
	#if bytes[0] != OK:
		#print("ERROR on receive")
		#reset_stream()
		#return ""
	#bytes = bytes[1]
#
	#print("received %d bytes" % [length])
	#print("bytes: ", bytes)
#
	#var data = proto.Data.new()
	#var res = data.from_bytes(bytes)
	#if res != proto.PB_ERR.NO_ERRORS:
		#print("ERROR could not deserialize")
		#reset_stream()
		#return ""
	#
	#reset_stream()
	#return "value: " + str(data.get_value()) + ", time: " + str(data.get_timestamp())
#
#func _on_connection_timeout() -> void:
	#timeout = true
#
#func reset_stream() -> void:
	#stream.disconnect_from_host()
	#stream = null
