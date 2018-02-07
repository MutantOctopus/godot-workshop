extends Node

var card_pos
var deck1
var deck2
var held_card = null

func _ready():
	card_pos = get_node("hold-pos").get_pos()
	deck1 = get_node("deck-1")
	deck2 = get_node("deck-2")

func draw_card():
	if held_card == null:
		var card = deck1.draw_card()
		if not card == null:
			card.set_pos(card_pos)
			add_child(card)
			card.flip()
			held_card = card

func place_card():
	if not held_card == null:
		deck2.place_card(held_card)
		held_card = null
