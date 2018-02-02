extends Sprite

func _ready():
	pass

# Fills the deck with 52 standard playing cards, with an optional specified
# texture for the backs of the cards.
func fill_deck(back = null):
	pass

# Shuffles the order of the cards currently in the deck.
func shuffle():
	pass

# Pops a card's data off the top of the deck, and retuns a node representing it.
# If the last card is taken, sets the sprite texture to null.
func draw_card():
	pass

# Places a card on the top of the deck.
func place_card(card):
	pass