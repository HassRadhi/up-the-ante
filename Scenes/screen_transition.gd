# ControlTransition.gd
extends CanvasLayer

signal transition_finished

@onready var trans_rect: TextureRect = $TextureRect
@onready var mat: ShaderMaterial = trans_rect.material

var duration := 0.5
var time := 0.0
var playing := false

func _ready() -> void:
	mat.set_shader_parameter("progress", 0.0)
	playing = false

func play_transition() -> void:
	if playing:
		return
	playing = true
	time = 0.0

func _process(delta: float) -> void:
	if !playing:
		return
	
	time += delta
	var progress = clamp(time / duration, 0.0, 2.2)
	print("progress = ", progress)
	mat.set_shader_parameter("progress", progress)

	if progress >= 2.2:
		playing = false
		emit_signal("transition_finished")
