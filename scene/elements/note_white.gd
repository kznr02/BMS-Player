extends Sprite2D

var id = 0
var lane = 0
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

func set_lane(num: int):
	self.lane = num

func get_lane() -> int:
	return self.lane

func move(y):
	position.y += y

func is_hit(limit: int):
	if self.position.y > limit:
		remove_from_group("notes")
		return true
	else:
		return false

func destroy():
	self.queue_free()
