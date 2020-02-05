extends CPUParticles2D

func _ready():
	yield(get_tree().create_timer(1), "timeout")
	emitting = false
	
	yield(get_tree().create_timer(4), "timeout")
	queue_free()
