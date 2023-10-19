extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_point(vec1: Vector2, vec2: Vector2):
	self.add_point(vec1)
	self.add_point(vec2)
	
func move(y):
	position.y += y

var id = 0
func set_bar_id(id: int):
	self.id = id

func get_bar_id() -> int:
	return id
	
func is_hit(y):
	if position.y > y:
		#print("Bar: {}".format([get_bar_id()], "{}"))
		#self.remove_from_group("bar_line")
		pass
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()
	pass # Replace with function body.
