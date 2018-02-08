extends Node

export(float, 0.0, 5.0, 0.1) var movement_time = 1.0

var card_pos
var deck1
var deck2
var tween
var held_card = null
var animating = false

func _ready():
	card_pos = get_node("hold-pos").get_pos()
	deck1 = get_node("deck-1")
	deck2 = get_node("deck-2")
	tween = get_node("Tween")

func draw_card():
	if held_card == null and not animating:
		var card = deck1.draw_card()
		if not card == null:
			card.set_pos(deck1.get_pos())
			add_child(card)
			card.flip()
			held_card = card
			
			# tween logic
			tween.interpolate_property(
				card,
				"transform/pos",
				deck1.get_pos(),
				card_pos,
				movement_time,
				Tween.TRANS_EXPO,
				Tween.EASE_OUT,
				0.2)
			animating = true
			tween.start()

func place_card():
	if not held_card == null and not animating:
		held_card.flip()
		# tween logic
		tween.interpolate_property(
			held_card,
			"transform/pos",
			card_pos,
			deck2.get_pos(),
			movement_time,
			Tween.TRANS_EXPO,
			Tween.EASE_OUT,
			0.2)
		animating = true
		tween.connect("tween_complete", self, "_on_place_card_end")
		tween.start()

func _on_tween_complete(obj, key):
	animating = false
	tween.remove_all()

func _on_place_card_end(obj, key):
	deck2.place_card(held_card)
	held_card = null
	tween.disconnect("tween_complete", self, "_on_place_card_end")
