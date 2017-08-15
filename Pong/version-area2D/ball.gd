extends Area2D

# +------------------------------------------------+
# | EXPORTED VARIABLES                             |
# +------------------------------------------------+
# The speed at which the ball starts
export(int, 0, 1000) var initial_speed = 80
# The value that 'speed' is multiplied by when
# bouncing off a paddle
export(float, 1.0, 4.0, 0.1) var speed_mult = 1.1

# +------------------------------------------------+
# | MEMBER VARiABLES                               |
# +------------------------------------------------+
# The current direction of the ball
var direction = Vector2(1,0)
# The current speed of the ball
var speed
# The size of the screen
# Initialized on _ready()
var screen_size

# +------------------------------------------------+
# | ENGINE FUNCTIONS                               |
# +------------------------------------------------+
func _ready():
	speed = initial_speed
	randomize()
	set_process(true)

# +------------------------------------------------+
# | MEMBER FUNCTIONS                               |
# +------------------------------------------------+
# Called when the ball is reset
func reset_ball():
	speed = initial_speed
	direction = Vector2(1,0)
	screen_size = get_viewport_rect().size
	set_pos(screen_size * 0.5)

# Called when the ball bounces off a paddle
func hit_paddle():
	speed *= 1.1 # Increase speed
	direction.x = -sign(direction.x)
	direction.y = randf() * 2 - 1
	direction = direction.normalized()

# +------------------------------------------------+
# | SIGNAL CALLBACKS                               |
# +------------------------------------------------+
# Callback for self.area_enter signal
func _on_area_enter(area):
	var groups = area.get_groups() # Array of strings
	if groups.has("paddle"): hit_paddle()
