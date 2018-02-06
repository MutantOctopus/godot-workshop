extends Sprite

# =================================================================== #
# EXPORT VARIABLES                                                    #
# =================================================================== #
# The backs of cards spawned by this deck.
export(Texture) var card_back
# Whether or not the deck should be autofilled as part of the _ready function,
# via the fill_deck function
export(bool) var auto_fill = true
# similar to above: after autofill in _ready, whether the deck should be shuffled
export(bool) var auto_shuffle = true
# determines whether the deck should display the back or the face of the
# top card
export(bool) var face_up = false

# =================================================================== #
# MEMBER VARIABLES                                                    #
# =================================================================== #
# "cards" is a list of dictionaries representing playing cards through the
# following data:
# "suit" : "joker", "hearts", "clubs", "diamonds" or "spades"
# "rank" : value from 0-13, with 0 representing a joker
# "back" : a Texture representing the card's back
var cards = []

# bool which indicates when the top of the deck has been updated.
# true means the texture needs to be reevaluated.
var _top_changed_flag = true setget _no_set
# Saved texture for the top of the deck.
# Isn't set until the deck is actually faceup.
var top_card_face = null

# =================================================================== #
# CONSTANTS                                                           #
# =================================================================== #
# Reference to card script, for accessing constants
const CARD_CLASS = preload("res://Elements/Card/card.gd")

# =================================================================== #
# ENGINE FUNCTIONS                                                    #
# =================================================================== #
func _ready():
	if auto_fill:
		fill_deck()
		if auto_shuffle:
			shuffle()
	else:
		update_sprite()

# =================================================================== #
# CLASS FUNCTIONS                                                     #
# =================================================================== #
# Fills the deck with 52 standard playing cards, with an optional specified
# texture for the backs of the cards. If a new back is specified, it will be
# used for the spawned cards, but will *not* change the default back for
# this deck.
func fill_deck(new_back = null):
	# error check
	if new_back != null and not (new_back extends Texture):
		new_back = null # so it won't be selected
		printerr("non-Texture value passed to fill_deck method")
	# determine which back to use
	var these_back = new_back if new_back != null else card_back
	
	# card creation loop
	for suit in CARD_CLASS.VALID_SUITS:
		if suit == "joker": continue # skip joker
		for rank in range (1,14): # returns values 1-13
			cards.append({"suit":suit, "rank":rank, "back":these_back})
	
	# since the deck's appearance might have changed...
	_top_changed_flag = true
	update_sprite()

# Shuffles the order of the cards currently in the deck.
# uses the fisher-yates shuffle algorithm
# UNTESTED
func shuffle():
	# this range will count down through the card list index, down to 1
	# note that range() returns an array of integers
	for i in range(1, cards.size()).invert():
		j = randi() % i
		var temp = cards[i]
		cards[i] = cards[j]
		cards[j] = temp
	_top_changed_flag = true
	update_sprite()

# Pops a card's data off the top of the deck, and retuns a node representing it.
# If the last card is taken, sets the sprite texture to null.
func draw_card():
	pass

# Takes a card node, and places it as data on top of the deck.
func place_card(card):
	pass

# updates the sprite
func update_sprite():
	var top_card = cards.back()
	if top_card == null: # there are no cards
		set_texture(null)
	elif face_up: # there is a card, and the deck is face-up
		if _top_changed_flag:
			top_card_face = CARD_CLASS.get_face_texture(top_card["suit"], top_card["rank"])
			_top_changed_flag = false
		set_texture(top_card_face)
	else: # there is a card, and the deck is face-down
		set_texture(top_card["back"])

# =================================================================== #
# SETTER FUNCTIONS                                                    #
# =================================================================== #
# sets whether the deck is face-up or face-down.
# If changed, updates the visuals of the deck.
func _set_facing(value):
	if value != face_up:
		face_up = value
		update_sprite()

# A function which does not set the requested value,
# used when a variable cannot be set outside the
# script.
func _no_set(value):
	printerr("Attempted to set an unsettable value to %s" % value)
