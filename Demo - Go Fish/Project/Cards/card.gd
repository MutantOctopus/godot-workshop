extends Sprite
# =================================================================== #
# EXPORT VARIABLES                                                    #
# =================================================================== #
# The back of the card. Defaults to the basic blue back if none is
# specified.
export(Texture) var card_back

# =================================================================== #
# MEMBER VARIABLES                                                    #
# =================================================================== #
# 'flipped' variable represents whether the card is currently
# face-up (true) or face-down (false)
# setter function: _set_flipped
# getter function: n/a
var flipped = false setget _set_flipped
# The current suit of the card. If not set to a valid suit, defaults
# to joker.
var suit = "joker"
# The current rank (ace, two, three... jack, queen, king) of the
# card. If the value is invalid, the card will be displayed as a
# joker. Valid values are 1-13.
var rank = 1
# The current card face. Cannot be set outside of this script.
var card_face setget _no_set

# =================================================================== #
# CONSTANTS                                                           #
# =================================================================== #
# The path to the default card back, used when 'card_back' is null on
# ready, currently the plain blue card back
const DEFAULT_BACK_PATH = "res://Cards/Backs/blue1.png"
# The path to the Joker card face.
const JOKER_PATH = "res://Cards/Faces/joker.png"
# List of valid suits for a card.
const VALID_SUITS = ["joker", "clubs", "spades", "diamonds", "hearts"]
# List which represents the various card ranks as text,
# e.g. ace, two, three... jack, queen, king
# 0 is 'joker' for buffer
const RANK_NAMES = ["joker", "ace", "two", "three", "four",
	"five", "six", "seven", "eight", "nine", "ten", "jack",
	"queen", "king"]

# =================================================================== #
# ENGINE FUNCTIONS                                                    #
# =================================================================== #
func _ready():
	if card_back == null:
		card_back = load(DEFAULT_BACK_PATH)
	#update_sprite()
	update_card_face()
	_set_flipped(true)

# =================================================================== #
# CLASS FUNCTIONS                                                     #
# =================================================================== #
# Updates the card's face texture.
func update_card_face():
	if suit == "joker":
		card_face = load("res://Cards/Faces/joker.png")
	else:
		var filename = rank
		if rank == 1 or rank > 10:
			filename = RANK_NAMES[rank]
		var path = "res://Cards/Faces/%s/%s.png" % [suit.capitalize(), filename]
		card_face = load(path)

# Updates the sprite to either the card back or the card face,
# based on the 'flipped' variable
func update_sprite():
	set_texture(card_face if flipped else card_back)

# =================================================================== #
# SETTER FUNCTIONS                                                    #
# =================================================================== #
# Setter function for the 'flipped' variable
func _set_flipped(value):
	if typeof(value) != TYPE_BOOL:
		printerr(
			"Attempt to set value of %s 'flipped' to non-boolean value %s"
			% [get_name(), value]
		)
		return
	elif value == (!flipped):
		# We only need to do anything if the new
		# value is different than the older value
		flipped = value
		update_sprite()

# Setter function for the 'suit' variable.
# Accepts "joker", "clubs", "hearts", "diamonds", or "spades" in
# any capitalization
func _set_suit(value):
	var new_suit = value.to_lower()
	# Check if new suit is actually valid
	if not (new_suit in VALID_SUITS):
		printerr("Attempted to set suit as invalid value '%s'" % value)
		new_suit = "joker"
	suit = new_suit

# A function which does not set the requested value,
# used when a variable cannot be set outside the
# script.
func _no_set(value):
	printerr("Attempted to set an unsettable value to %s" % value)
