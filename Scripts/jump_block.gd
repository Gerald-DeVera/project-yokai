extends Node2D

@onready var bounceAni = $AnimationPlayer
@export var oomph = -500.0

func _on_area_2d_area_entered(area: Area2D) -> void:
	Signals.changePlayerVelocity.emit(oomph)
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	Signals.returnToOriginalVelocity.emit()
	bounceAni.play("bounce")
