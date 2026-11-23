
extends CharacterBody2D

const GRAVEDAD = 980.0
const FUERZA_SALTO = -400.0
const TIEMPO_BUFFER = 0.15
const TIEMPO_COYOTE = 0.12

var temporizador_buffer = 0.0
var temporizador_coyote = 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		temporizador_coyote = TIEMPO_COYOTE
	else:
		temporizador_coyote = max(temporizador_coyote - delta, 0.0)

	if Input.is_action_just_pressed("saltar"):
		# RETO 1: Guardar la pulsación

	# RETO 2: Reducir el temporizador del buffer

	# RETO 3: Ejecutar el salto cuando ambos
	# temporizadores sean mayores que cero

	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	move_and_slide()
