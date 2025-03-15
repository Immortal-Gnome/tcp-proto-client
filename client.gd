class_name Client
extends Node

var status: int = 0
@onready var stream: StreamPeerTCP = StreamPeerTCP.new()

func _ready() -> void:
	status = stream.get_status()

func connect_to_host(host: String, port: int) -> void:
	print("Connecting to %s:%d" % [host, port])
	status = stream.STATUS_NONE

	if stream.connect_to_host(host, port) != OK:
		print("ERROR connecting to host.")
		return
	
	while (stream.get_available_bytes() == 0):
		stream.poll()
	var length = stream.get_available_bytes()
	var _data = stream.get_data(length)
	print("received %d bytes" % [length])
