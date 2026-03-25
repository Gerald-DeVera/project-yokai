extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	Signals.changePlayerVelocity.emit(-750.0)
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	Signals.returnToOriginalVelocity.emit()
