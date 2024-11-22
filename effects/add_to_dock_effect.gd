class_name AddToDockEffect
extends Effect

var card: Card

func _init(card: Card = null):
	self.card = card

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Dock:
			var placed_successfully = target.add_card_to_dock(card)
