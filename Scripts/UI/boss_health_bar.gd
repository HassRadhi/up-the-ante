extends Node2D

@onready var progress = $ProgressBar
@onready var sprite = $AnimatedSprite2D
var period:float = 0.3

func _ready():
	SignalBus.damage_boss.connect(_on_damage_boss)

func _reduce_health(damage : float):
	progress.value = lerp(progress.value, progress.value - damage, 1)
	if progress.value <= progress.max_value / 2:
		sprite.play("frog_phase2")

func _shake_healthbar(damage : float):
	var initial_transform:Transform2D = self.transform
	var elapsed_time:float = 0.0
	while elapsed_time < period:
		var off = Vector2(
		randf_range(-damage, damage),
		randf_range(-damage, damage),
		)
		self.transform.origin = initial_transform.origin + off
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
		self.transform = initial_transform

func _on_damage_boss(damage: float) -> void:
	_reduce_health(damage)
	_shake_healthbar(damage * 5)
