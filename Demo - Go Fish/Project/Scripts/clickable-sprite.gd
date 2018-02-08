extends Sprite

signal clicked()

func _ready():
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
		# create variables
		var tex_size = get_texture().get_size()
		var tex_rect = Rect2(-tex_size * 0.5, tex_size)
		
		if tex_rect.has_point(parent.get_local_mouse_pos()):
			# debug print to be commented out later
			print("clicked " + parent.get_name())
			# if this statement is not here, the click will be seen by
			# sprites 'under' this one
			get_tree().set_input_as_handled()
			emit_signal("clicked")