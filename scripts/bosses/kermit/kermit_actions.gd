extends CharacterBody2D

signal boss_collision_start
signal boss_collision_end

func _ready():
	BossHandler.set_current_boss(self)

func _on_boss_hurtbox_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	boss_collision_start.emit()

func _on_boss_hurtbox_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	boss_collision_end.emit()
