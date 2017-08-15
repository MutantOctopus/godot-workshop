extends Area2D

# +------------------------------------------------+
# | EXPORT VARIABLES                               |
# +------------------------------------------------+
# The speed at which the paddle can move
export(int, 0, 1000) var speed = 150
# Whether or not the paddle is computer controlled
export(bool) var com_player = false

# +------------------------------------------------+
# | ENGINE FUNCTIONS                               |
# +------------------------------------------------+
func _ready():
	set_process(true)

func _process(delta):
	pass
