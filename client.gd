class_name Client
extends Node

var status: int = 0
@onready var stream: StreamPeerTCP = StreamPeerTCP.new()
@onready var timeout_timer: Timer = Timer.new()

const proto = preload("res://proto/data.proto.gd")

var timeout: bool = false

func _ready() -> void:
	status = stream.get_status()
	timeout_timer.autostart = false
	timeout_timer.one_shot = true
	timeout_timer.wait_time = 5.0
	add_child(timeout_timer)
	timeout_timer.timeout.connect(_on_connection_timeout)

func connect_to_host(host: String, port: int) -> String:
	print("Connecting to %s:%d" % [host, port])
	status = stream.STATUS_NONE

	if stream.connect_to_host(host, port) != OK:
		print("ERROR connecting to host.")
		return ""
		
	print("INFO connected to ", stream.get_connected_host(), ':', stream.get_connected_port())
	print("INFO port ", stream.get_local_port())
	
	timeout_timer.start()
	while (stream.get_status() == StreamPeerTCP.STATUS_CONNECTING):
		if timeout:
			print("ERROR timeout")
			stream.disconnect_from_host()
			return ""
		await get_tree().create_timer(0.1).timeout
		stream.poll()
	
	if stream.get_status() == StreamPeerTCP.STATUS_ERROR:
		print("ERROR CONNECTING!!!")
		return "FUCK"
	
	var length = stream.get_available_bytes()
	var bytes = stream.get_data(length)
	if bytes[0] != OK:
		print("ERROR on receive")
		return ""
	bytes = bytes[1]

	print("received %d bytes" % [length])
	print("bytes: ", bytes)

	var data = proto.Data.new()
	var res = data.from_bytes(bytes)
	if res != proto.PB_ERR.NO_ERRORS:
		print("ERROR could not deserialize")
		return ""
	
	return "value: " + str(data.get_value()) + ", time: " + str(data.get_timestamp())

func _on_connection_timeout() -> void:
	timeout = true
