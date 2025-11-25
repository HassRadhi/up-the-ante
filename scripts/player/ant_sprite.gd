extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(apply_hit_affect)

func apply_hit_affect() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:v", 1, 0.25).from(15)
	
