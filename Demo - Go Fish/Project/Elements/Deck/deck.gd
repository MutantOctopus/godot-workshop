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

# bool which indicates that the top of the deck has been changed since
# the last time the face of the top card was shown, and therefore the
# texture needs to be reloaded when the deck is next flipped over.
var _reload_face = true setget _no_set
# Saved texture for the top of the deck.
# Isn't set until the deck is actually faceup.
var top_card_face = null

# =================================================================== #
# CONSTANTS                                                           #
# =================================================================== #
# Reference to card script, for accessing constants
const CARD_CLASS = preload("res://Elements/Card/card.gd")
# reference to card scene, for creating cards
const CARD_SCENE = preload("res://Elements/Card/card.tscn")

# =================================================================== #
# ENGINE FUNCTIONS                                                    #
# =================================================================== #
func _ready():
	# without this function call, shuffle will return the same sequence
	# of results each time.
	randomize()
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
	update_sprite()

# Shuffles the order of the cards currently in the deck.
# uses the fisher-yates shuffle algorithm
# UNTESTED
func shuffle():
	# this range will count down through the card list index, down to 1
	# note that range() returns an array of integers
	var nums = range(1, cards.size())
	# note for future reference:
	# invert operates on the array, doesn't return a new array
	nums.invert()
	for i in nums:
		var j = randi() % i
		var temp = cards[i]
		cards[i] = cards[j]
		cards[j] = temp
	update_sprite()

# Pops a card's data off the top of the deck, and retuns a node representing it.
# If the last card is taken, sets the sprite texture to null.
# If there is no card in the deck, returns null.
func draw_card():
	if cards.size() == 0:
		printerr("Attempted to draw card from empty deck.")
		return null
	else:
		# notice that 'pop' methods unintuitively do not return the popped item
		var card_data = cards.back()
		cards.pop_back()
		var card = CARD_SCENE.instance()
		card.suit = card_data["suit"]
		card.rank = card_data["rank"]
		card.back = card_data["back"]
		update_sprite()
		return card

# Takes a card node, places it as data on top of the deck, and queues
# the node to be deleted from memory.
# Assumes that the card has not been removed from the scene tree.
func place_card(card):
	cards.append({"suit": card.suit, "rank": card.rank, "back": card.back})
	card.queue_free()
	update_sprite()

# updates the sprite
# optional argument says whether the top card of the deck has been
# changed; defaults to true.
func update_sprite(top_changed = true):
	if cards.size() == 0:
		# no cards = no texture, and we can end here.
		# this encompasses both faceup and facedown, so we
		# can ignore the _reload_face flag.
		set_texture(null)
	else:
		var top_card = cards.back()
		if not face_up:
			# if we aren't currently faceup, we can skip loading
			# the new card face texture; however, we need to flag that
			# the texture will need to be loaded later.
			# _reload_face is our flag for this occasion.
			_reload_face = _reload_face or top_changed
			set_texture(top_card["back"])
		else:
			# `top_changed or _reload_face` tells us if we need a new
			# card texture.
			if top_changed or _reload_face:
				top_card_face = CARD_CLASS.get_face_texture(
					top_card["suit"], top_card["rank"])
				# now that the new face has been loaded, we no longer
				# need to have this flag raised
				_reload_face = false
			set_texture(top_card_face)

# =================================================================== #
# SETTER FUNCTIONS                                                    #
# =================================================================== #
# sets whether the deck is face-up or face-down.
# If changed, updates the visuals of the deck.
func _set_facing(value):
	if value != face_up:
		face_up = value
		# Since we aren't changing the top of the deck, merely flipping
		# the cards over, we don't need to update the sprite.
		# hence, we pass the optional 'false'.
		update_sprite(false)

# A function which does not set the requested value,
# used when a variable cannot be set outside the
# script.
func _no_set(value):
	printerr("Attempted to set an unsettable value to %s" % value)
