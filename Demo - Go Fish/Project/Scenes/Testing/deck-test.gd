extends Node

var card_pos
var deck

func _ready():
	card_pos = get_node("pos").get_pos()
	deck = get_node("deck")

func draw_card():
	var card = deck.draw_card()
	if not card == null:
		card.set_pos(card_pos)
		add_child(card)
		card.flip()
