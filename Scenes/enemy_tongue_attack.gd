extends State
class_name EnemyTongueAttack

@export var enemy : CharacterBody2D
@onready var tongue = enemy.get_node("Tongue")

func enter():
	await get_tree().process_frame
	BossHandler.sprite.play("TongueAttack2")
	await BossHandler.sprite.animation_finished
	BossHandler.sprite.frame = 0
	
	var tongueSprite = tongue.get_node("AnimatedSprite2D")
	tongueSprite.visible = true
	tongueSprite.play("default")
	await tongueSprite.animation_finished
	var tween = create_tween()
	tween.tween_property(tongue, "global_position", get_viewport().get_visible_rect().get_center() + Vector2(700, -500), 0.3)
	tween.parallel().tween_property(tongueSprite, "scale", Vector2(15,15), 0.35)
	await tween.finished
	
	tongueSprite.visible = false
	SignalBus.blur_screen.emit()
	
	transitioned.emit(self, "EnemyStomp")
