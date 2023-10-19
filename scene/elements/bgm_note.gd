extends Sprite2D

var id = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_obj_id(id):
	self.id = id
	pass

func get_obj_id():
	return self.id

func move(y):
	position.y += y
	
func is_hit(limit: int):
	if self.position.y > limit:
		remove_from_group("bgm_notes")
		return true
	else:
		return false
		
func destroy():
	self.queue_free()
