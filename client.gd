class_name Client
extends Node

var status: int = 0
@onready var stream: StreamPeerTCP = StreamPeerTCP.new()

const proto = preload("res://proto/data.proto.gd")

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
	var bytes = stream.get_data(length)
	print("received %d bytes" % [length])
	print("bytes: ", bytes)

	var data = proto.Data.new()
	var res = data.from_bytes(bytes[1])
	if res != proto.PB_ERR.NO_ERRORS:
		print("ERROR could not deserialize")
		return
	
	print(data.get_value())
	print(data.get_timestamp())
