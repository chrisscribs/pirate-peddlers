class_name ModifierEffect
extends Effect

var amount := 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Dock or target is Player:
			target.stats.modifier += amount
