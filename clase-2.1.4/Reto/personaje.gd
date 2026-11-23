extends CharacterBody2D

# ==============================================================================
# Script: Personaje.gd
# Descripción: Demostración didáctica de Buffer de Entrada e Input Forgiveness
#              combinado con Coyote Time en un juego de plataformas 2D.
# ==============================================================================

# --- Parámetros de Movimiento Físico ---
const VELOCIDAD_HORIZONTAL: float = 260.0
const GRAVEDAD: float = 1200.0
const FUERZA_SALTO: float = -600.0

# --- Ventanas de Tiempo (Tolerancia / Forgiveness) ---
# Tiempo durante el cual se guarda una pulsación antes de tocar el suelo
const TIEMPO_BUFFER: float = 0.15
# Tiempo de gracia para saltar luego de caer de una plataforma
const TIEMPO_COYOTE: float = 0.12

# --- Banderas de Configuración para Pruebas en Vivo ---
# Permite alternar la activación para notar la diferencia de control
@export var buffer_activo: bool = true
@export var coyote_activo: bool = true

# --- Temporizadores Internos (en segundos) ---
var temporizador_buffer: float = 0.0
var temporizador_coyote: float = 0.0

# --- Referencias visuales para Feedback Inmediato ---
@onready var sprite: ColorRect = $Visual
@onready var color_original: Color = $Visual.color

func _physics_process(delta: float) -> void:
	# --------------------------------------------------------------------------
	# 1. GESTIÓN DEL COYOTE TIME (Salto tardío tras dejar el borde)
	# --------------------------------------------------------------------------
	if is_on_floor():
		# Mientras esté en el suelo, el tiempo de coyote se mantiene completo
		temporizador_coyote = TIEMPO_COYOTE
	else:
		# En el aire, se descuenta el tiempo solo si la opción está activa
		if coyote_activo:
			temporizador_coyote = max(temporizador_coyote - delta, 0.0)
		else:
			temporizador_coyote = 0.0

	# --------------------------------------------------------------------------
	# 2. GESTIÓN DEL BUFFER DE ENTRADA (Salto anticipado antes del suelo)
	# --------------------------------------------------------------------------
	if Input.is_action_just_pressed("saltar"):
		# Si el buffer está activo, conservamos la intención por TIEMPO_BUFFER s
		# Si está inactivo, solo dura el frame actual (delta)
		temporizador_buffer = TIEMPO_BUFFER if buffer_activo else delta
	else:
		# Si no se presionó en este frame, reducimos la ventana del buffer
		temporizador_buffer = max(temporizador_buffer - delta, 0.0)

	# --------------------------------------------------------------------------
	# 3. APLICAR GRAVEDAD
	# --------------------------------------------------------------------------
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	# --------------------------------------------------------------------------
	# 4. RESOLUCIÓN DEL SALTO
	# Se ejecuta si hay una orden válida en buffer Y si hay tolerancia de suelo
	# --------------------------------------------------------------------------
	if temporizador_buffer > 0.0 and temporizador_coyote > 0.0:
		velocity.y = FUERZA_SALTO
		
		# Consumir los buffers para no disparar saltos repetidos no deseados
		temporizador_buffer = 0.0
		temporizador_coyote = 0.0
		
		# Efecto visual breve de feedback
		_destello_salto()

	# --------------------------------------------------------------------------
	# 5. MOVIMIENTO HORIZONTAL BÁSICO
	# --------------------------------------------------------------------------
	var direccion: float = Input.get_axis("mover_izquierda", "mover_derecha")
	velocity.x = direccion * VELOCIDAD_HORIZONTAL

	# --------------------------------------------------------------------------
	# 6. ALTERNAR MODOS EN VIVO CON TECLADO (Tecla B y Tecla C)
	# --------------------------------------------------------------------------
	if Input.is_action_just_pressed("alternar_buffer"):
		buffer_activo = not buffer_activo
	if Input.is_action_just_pressed("alternar_coyote"):
		coyote_activo = not coyote_activo

	# Aplicar movimiento cinemático y detección de colisiones
	move_and_slide()

# Función auxiliar para dar feedback visual instantáneo al saltar
func _destello_salto() -> void:
	if sprite:
		sprite.color = Color.YELLOW
		var tween = create_tween()
		tween.tween_property(sprite, "color", color_original, 0.12)
