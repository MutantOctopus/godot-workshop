extends Area2D

# +------------------------------------------------+
# | EXPORTED VARIABLES                             |
# +------------------------------------------------+
# The path to the ball
export(NodePath) var ball
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
# Height of the screen
var screen_height

# +------------------------------------------------+
# | ENGINE FUNCTIONS                               |
# +------------------------------------------------+
func _ready():
	# 'hitbox' node is expected to have a capsule shape
	var paddle_capsule = get_node("hitbox").get_shape()
	# Capsule is two halves of a circle with a rectangle in
	# the middle. 'get_height()' is the height of the
	# RECTANGLE, and the full size is the height plus
	# the diameter of the circle (half is 1/2 get_height +
	# radius)
	half_paddle_height =\
		paddle_capsule.get_height() * 0.5\
		+ paddle_capsule.get_radius()
	# Vector2.height == Vector2.y
	screen_height = get_viewport_rect().size.height
	set_process(true)

func _process(delta):
	var movement = Vector2()
	# Just shortening so we don't need to call the full name
	var pos_y = get_pos().y
	# Upward movement
	if ((pos_y > half_paddle_height) # Can we move up?
	and (
		# If we're human controlled, is the "move up" action pressed?
		(not com_player and Input.is_action_pressed(move_up_action))
		# If we're computer controlled, is the ball beyond our accurcacy margin?
		or (com_player and get_node(ball).get_pos().y < (pos_y - com_accuracy))
	)):
		#print("Up!")
		movement += Vector2(0, -1)
	# Downward movement
	if ((pos_y < screen_height - half_paddle_height) # Can we move down?
	and (
		# If we're human controlled, is the "move down" action pressed?
		(not com_player and Input.is_action_pressed(move_down_action))
		# If we're computer controlled, is the ball beyond our accuracy margin?
		or (com_player and get_node(ball).get_pos().y > (pos_y + com_accuracy))
	)):
		#print("Down!")
		movement += Vector2(0, 1)
	
	movement *= speed * delta
	set_pos(get_pos() + movement)
