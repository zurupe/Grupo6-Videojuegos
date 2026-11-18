extends CharacterBody2D

# R5: La velocidad se puede cambiar desde el Inspector
@export var velocidad: float = 300.0

func _physics_process(_delta: float) -> void:
	# R5: El Player se mueve a izquierda y derecha con las acciones
	var direccion: float = Input.get_axis("move_left", "move_right")
	velocity.x = direccion * velocidad
	move_and_slide()
