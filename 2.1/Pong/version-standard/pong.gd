extends Node2D

# Constants
# ----------------------------
# The speed the ball starts at
const INITIAL_BALL_SPEED = 80
# The speed the paddles move at
const PAD_SPEED = 150

# Member variables
# ----------------------------
# Size of the window
var screen_size
# Size of the paddle
var pad_size
# Direction of the ball
var direction = Vector2(1, 0)
# Current speed of the ball (increases on bounce against paddle)
var ball_speed = INITIAL_BALL_SPEED

# Called when added to the scene tree, once all children are ready
func _ready():
	screen_size = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	set_process(true)

# Called once before every frame
# 'delta' => The amount of time (sec) since the last _process call
func _process(delta):
	var ball_pos = get_node("ball").get_pos()
	var left_rect = Rect2(get_node("left").get_pos() - pad_size * 0.5, pad_size)
	var right_rect = Rect2(get_node("right").get_pos() - pad_size * 0.5, pad_size)
	
	ball_pos += direction * ball_speed * delta
	
	# Change direction when ceiling/floor is touched
	if ((ball_pos.y < 0 and direction.y < 0) \
	or (ball_pos.y > screen_size.y and direction.y > 0)):
		direction.y = -direction.y
	
	# Flip and increase speed when paddle is hit
	if ((left_rect.has_point(ball_pos) and direction.x < 0) \
	or (right_rect.has_point(ball_pos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
		ball_speed *= 1.1
	
	# Check gameover
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		ball_pos = screen_size * 0.5
		ball_speed = INITIAL_BALL_SPEED
		direction = Vector2(1, 0)
	
	# Set ball position
	get_node("ball").set_pos(ball_pos)
	
	# Move left pad
	var left_pos = get_node("left").get_pos()
	
	if (left_pos.y > 0 and Input.is_action_pressed("left_move_up")):
		left_pos.y += -PAD_SPEED * delta
	if (left_pos.y < screen_size.y and Input.is_action_pressed("left_move_down")):
		left_pos.y += PAD_SPEED * delta
	
	get_node("left").set_pos(left_pos)
	
	# Move right pad
	var right_pos = get_node("right").get_pos()
	
	if (right_pos.y > 0 and Input.is_action_pressed("right_move_up")):
		right_pos.y += -PAD_SPEED * delta
	if (right_pos.y < screen_size.y and Input.is_action_pressed("right_move_down")):
		right_pos.y += PAD_SPEED * delta
	
	get_node("right").set_pos(right_pos)
