extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(_apply_hit_affect)

func _apply_hit_affect() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, 0.5).from(15)
