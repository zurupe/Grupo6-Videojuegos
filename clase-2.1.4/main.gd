extends Node2D

@onready var personaje = $Personaje
@onready var lbl_buffer = $HUD/Panel/VBoxContainer/LblBuffer
@onready var lbl_coyote = $HUD/Panel/VBoxContainer/LblCoyote
@onready var lbl_estado = $HUD/Panel/VBoxContainer/LblEstado
@onready var bar_buffer = $HUD/Panel/VBoxContainer/BarBuffer
@onready var bar_coyote = $HUD/Panel/VBoxContainer/BarCoyote

func _ready() -> void:
	bar_buffer.max_value = personaje.TIEMPO_BUFFER
	bar_coyote.max_value = personaje.TIEMPO_COYOTE

func _process(_delta: float) -> void:
	if not personaje:
		return
		
	# Actualizar etiquetas de estado de Buffer
	if personaje.buffer_activo:
		lbl_buffer.text = "Buffer de Entrada: ACTIVADO (0.15s)"
		lbl_buffer.modulate = Color.GREEN
	else:
		lbl_buffer.text = "Buffer de Entrada: DESACTIVADO (0s)"
		lbl_buffer.modulate = Color.SALMON

	# Actualizar etiquetas de estado de Coyote Time
	if personaje.coyote_activo:
		lbl_coyote.text = "Coyote Time: ACTIVADO (0.12s)"
		lbl_coyote.modulate = Color.GREEN
	else:
		lbl_coyote.text = "Coyote Time: DESACTIVADO (0s)"
		lbl_coyote.modulate = Color.SALMON

	# Actualizar barras de tiempo en vivo
	bar_buffer.value = personaje.temporizador_buffer
	bar_coyote.value = personaje.temporizador_coyote
	
	# Indicador de estado del personaje
	if personaje.is_on_floor():
		lbl_estado.text = "Estado: EN EL SUELO"
		lbl_estado.modulate = Color.WHITE
	else:
		lbl_estado.text = "Estado: EN EL AIRE"
		lbl_estado.modulate = Color.LIGHT_BLUE
