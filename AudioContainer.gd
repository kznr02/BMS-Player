extends AudioStreamPlayer

var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_rsc_id(id: int):
	self.id = id
	
func get_rsc_id() -> int: 
	return self.id
	
func set_stream_and_disable_loop(stream):
	stream.loop = false
	self.set_stream(stream)

func play_audio(id):
	if id == self.id:
		self.play()
