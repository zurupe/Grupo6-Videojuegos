extends Node2D

@onready var hud: Label = $Hud

# R4: Dos contadores para move_right
var cuadros_pulsados: int = 0
var eventos_recibidos: int = 0

# R3: Información del último evento
var ultimo_evento_clase: String = "Ninguno"
var ultimo_dispositivo: String = "Ninguno"
var ultimo_tipo_senal: String = "Ninguno"
var ultimo_detalle: String = "Presiona una tecla o interactúa con un dispositivo..."


func _physics_process(_delta: float) -> void:
	# R4: Contar cuadros con la acción move_right pulsada (sondeo / polling)
	if Input.is_action_pressed("move_right"):
		cuadros_pulsados += 1

	actualizar_hud()


func _input(event: InputEvent) -> void:
	# R3: El eco del teclado se ignora
	if event is InputEventKey and event.is_echo():
		return

	# R4: Eventos recibidos para move_right
	if event.is_action_pressed("move_right"):
		eventos_recibidos += 1

	# R3: Registro del último evento, dispositivo y tipo de señal
	if event is InputEventKey:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Teclado (Dispositivo %d)" % event.device
		ultimo_tipo_senal = "Digital"
		var key_str: String = OS.get_keycode_string(event.physical_keycode if event.physical_keycode != 0 else event.keycode)
		ultimo_detalle = "Tecla '%s' (%s)" % [key_str, "Pulsada" if event.pressed else "Liberada"]

	elif event is InputEventMouseButton:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Ratón (Dispositivo %d)" % event.device
		# R3: La rueda del ratón se distingue de un clic (su rama va antes que la del clic)
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_LEFT, MOUSE_BUTTON_WHEEL_RIGHT]:
			var dir_rueda: String = "Arriba" if event.button_index == MOUSE_BUTTON_WHEEL_UP else ("Abajo" if event.button_index == MOUSE_BUTTON_WHEEL_DOWN else "Lateral")
			ultimo_tipo_senal = "Digital / Discreta (Rueda)"
			ultimo_detalle = "Rueda del ratón hacia %s" % dir_rueda
		else:
			var btn_nombre: String = "Izquierdo" if event.button_index == MOUSE_BUTTON_LEFT else ("Derecho" if event.button_index == MOUSE_BUTTON_RIGHT else ("Central" if event.button_index == MOUSE_BUTTON_MIDDLE else str(event.button_index)))
			ultimo_tipo_senal = "Digital (Clic)"
			ultimo_detalle = "Clic %s (%s)" % [btn_nombre, "Pulsado" if event.pressed else "Liberado"]

	elif event is InputEventMouseMotion:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Ratón (Dispositivo %d)" % event.device
		ultimo_tipo_senal = "Posición"
		ultimo_detalle = "Posición: (%.1f, %.1f)" % [event.position.x, event.position.y]

	elif event is InputEventJoypadButton:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Mando (Dispositivo %d)" % event.device
		ultimo_tipo_senal = "Digital"
		ultimo_detalle = "Botón: %d (%s)" % [event.button_index, "Pulsado" if event.pressed else "Liberado"]

	elif event is InputEventJoypadMotion:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Mando (Dispositivo %d)" % event.device
		ultimo_tipo_senal = "Analógica"
		ultimo_detalle = "Eje: %d | Valor: %.2f" % [event.axis, event.axis_value]

	elif event is InputEventScreenTouch:
		ultimo_evento_clase = event.get_class()
		ultimo_dispositivo = "Pantalla Táctil"
		ultimo_tipo_senal = "Posición"
		ultimo_detalle = "Toque en: (%.1f, %.1f) (%s)" % [event.position.x, event.position.y, "Pulsado" if event.pressed else "Liberado"]


func actualizar_hud() -> void:
	# R2: El Hud muestra jump como verdadero o falso, y get_axis y get_action_strength("move_right") con 2 decimales
	var jump_presionado: bool = Input.is_action_pressed("jump")
	var jump_texto: String = "verdadero" if jump_presionado else "falso"
	var axis_horizontal: float = Input.get_axis("move_left", "move_right")
	var fuerza_move_right: float = Input.get_action_strength("move_right")

	hud.text = (
		"=== PANEL DE CONTROLES (HUD) ===\n" +
		"jump: %s\n" % jump_texto +
		"get_axis(\"move_left\", \"move_right\"): %.2f\n" % axis_horizontal +
		"get_action_strength(\"move_right\"): %.2f\n\n" +
		"--- Contadores move_right (D) ---\n" +
		"Cuadros con la acción pulsada (sondeo): %d\n" % cuadros_pulsados +
		"Eventos recibidos (_input): %d\n\n" +
		"--- Último Evento Recibido ---\n" +
		"Clase de evento: %s\n" % ultimo_evento_clase +
		"Dispositivo: %s\n" % ultimo_dispositivo +
		"Tipo de señal: %s\n" % ultimo_tipo_senal +
		"Detalle: %s" % ultimo_detalle
	)
