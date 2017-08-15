extends Area2D

# +------------------------------------------------+
# | EXPORTED VARIABLES                             |
# +------------------------------------------------+
# The speed at which the paddle can move
export(int, 0, 1000) var speed = 150
# The Input Action which moves the paddle up.
export(String) var move_up_action
# The Input Action which moves the paddle down.
export(String) var move_down_action
# Whether or not the paddle is computer controlled
export(bool) var com_player = false
# The amount of pixels ± from the center of the
# paddle that an AI paddle will try to 'chase' the
# ball.
export(int, 0, 400) var com_accuracy = 5

# +------------------------------------------------+
# | MEMBER VARiABLES                               |
# +------------------------------------------------+
# Half the height of the paddle's hitbox.
# Only half, because everything is measured from
# the center of the paddle.
var half_paddle_height

# +------------------------------------------------+
# | ENGINE FUNCTIONS                               |
# +------------------------------------------------+
func _ready():
	# This will act weird if the "hitbox" child
	# node's Shape2D isn't a CapsuleShape2D
	half_paddle_height = get_node("hitbox") \
		.get_shape() \
		.get_height() * 0.5
	set_process(true)

func _process(delta):
	var movement = Vector2()
	if not com_player: # Human player
		pass
	else: # Computer player
		pass
