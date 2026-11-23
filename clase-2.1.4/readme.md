# Demostración Práctica: Buffer de Entrada (Input Buffering) y Coyote Time en Godot 4

Este proyecto es la solución al **Paso 3 (Prepara el ejercicio)** para la presentación y demostración en vivo (~8 minutos) en Godot 4.7.x.

---

## 🎯 Cumplimiento de Requisitos

| Requisito | Descripción | Estado |
| :--- | :--- | :---: |
| **E1** | Hecho en **Godot 4.7.x** con GDScript y diseñado para resolverse en vivo en **~8 minutos**. | ✅ |
| **E2** | Demuestra el subtema: **Buffer de entrada**, ventana de tiempo y combinación con **Coyote Time**. Salto con buffer activado/desactivado. | ✅ |
| **E3** | Resultado visible en pantalla: movimiento físico del personaje, destello en el salto, panel UI con etiquetas de estado y barras de progreso en tiempo real. | ✅ |
| **E4** | Código propio, legible, modular y completamente comentado. | ✅ |
| **E5** | Entregado con la **guía paso a paso escrita** (ver abajo) para que cualquier compañero o docente pueda replicarlo exactamente. | ✅ |

---

## 🎮 Controles de la Demostración

* **A / D** o **Flechas Izquierda / Derecha**: Mover el personaje horizontalmente.
* **Espacio** o **W**: Saltar.
* **B**: Alternar Buffer de Entrada (*ACTIVADO / DESACTIVADO*).
* **C**: Alternar Coyote Time (*ACTIVADO / DESACTIVADO*).

> **Nota:** Si una acción no responde al probar, haz clic dentro de la ventana del juego para asegurarte de que tiene el foco.

---

## 📋 Guía Paso a Paso para la Demostración en Vivo (~8 minutos)

### Paso 1: Configurar el Mapa de Entradas (Input Map) (1 minuto)
1. Abrir Godot 4 y crear/abrir el proyecto.
2. Ir a **Proyecto → Configuración del proyecto... → Mapa de entradas**.
3. Añadir las siguientes acciones:
   * `saltar` ➔ Añadir teclas **Espacio** y **W**.
   * `mover_izquierda` ➔ Añadir teclas **A** y **Flecha Izquierda**.
   * `mover_derecha` ➔ Añadir teclas **D** y **Flecha Derecha**.
   * `alternar_buffer` ➔ Añadir tecla **B**.
   * `alternar_coyote` ➔ Añadir tecla **C**.

---

### Paso 2: Crear el Personaje y su Script (3 minutos)
1. Crear una escena con nodo raíz `CharacterBody2D`, renombrarlo a `Personaje`.
2. Añadir como hijos:
   * Un `CollisionShape2D` con forma `RectangleShape2D` (ej. 36x48 px).
   * Un `ColorRect` llamado `Visual` (ej. 36x48 px, centrado de -18 a 18 y -24 a 24) con color celeste.
3. Adjuntar el script [personaje.gd](file:///home/zurupe/Documentos/ESPE/8voSemestre/Desarrollo de VIdeojuegos/Grupo6-Videojuegos/clase-2.1.4/personaje.gd):

```gdscript
extends CharacterBody2D

# --- Parámetros Físicos ---
const VELOCIDAD_HORIZONTAL: float = 260.0
const GRAVEDAD: float = 1200.0
const FUERZA_SALTO: float = -600.0

# --- Ventanas de Tiempo (Input Buffering y Coyote Time) ---
const TIEMPO_BUFFER: float = 0.15 # 150 ms para recordar la pulsación anticipada
const TIEMPO_COYOTE: float = 0.12 # 120 ms de gracia tras caer de un borde

@export var buffer_activo: bool = true
@export var coyote_activo: bool = true

var temporizador_buffer: float = 0.0
var temporizador_coyote: float = 0.0

@onready var sprite: ColorRect = $Visual
@onready var color_original: Color = $Visual.color

func _physics_process(delta: float) -> void:
	# 1. Coyote Time: Si está en el suelo se recarga; en el aire se agota con delta
	if is_on_floor():
		temporizador_coyote = TIEMPO_COYOTE
	else:
		temporizador_coyote = max(temporizador_coyote - delta, 0.0) if coyote_activo else 0.0

	# 2. Buffer de Entrada: Si pulsa salto, se almacena por 0.15s
	if Input.is_action_just_pressed("saltar"):
		temporizador_buffer = TIEMPO_BUFFER if buffer_activo else delta
	else:
		temporizador_buffer = max(temporizador_buffer - delta, 0.0)

	# 3. Gravedad
	if not is_on_floor():
		velocity.y += GRAVEDAD * delta

	# 4. Evaluación del Salto: Requiere intención en buffer Y tolerancia de suelo
	if temporizador_buffer > 0.0 and temporizador_coyote > 0.0:
		velocity.y = FUERZA_SALTO
		temporizador_buffer = 0.0 # Se consumen inmediatamente
		temporizador_coyote = 0.0
		_destello_salto()

	# 5. Movimiento horizontal
	var direccion: float = Input.get_axis("mover_izquierda", "mover_derecha")
	velocity.x = direccion * VELOCIDAD_HORIZONTAL

	# 6. Alternar modos en vivo para comparación
	if Input.is_action_just_pressed("alternar_buffer"):
		buffer_activo = not buffer_activo
	if Input.is_action_just_pressed("alternar_coyote"):
		coyote_activo = not coyote_activo

	move_and_slide()

func _destello_salto() -> void:
	if sprite:
		sprite.color = Color.YELLOW
		var tween = create_tween()
		tween.tween_property(sprite, "color", color_original, 0.12)
```

---

### Paso 3: Crear el Escenario y la Interfaz HUD (2 minutos)
1. Crear una escena principal `Main` (`Node2D`) y adjuntarle [main.gd](file:///home/zurupe/Documentos/ESPE/8voSemestre/Desarrollo de VIdeojuegos/Grupo6-Videojuegos/clase-2.1.4/main.gd).
2. Añadir un suelo y dos plataformas flotantes utilizando nodos `StaticBody2D` con `CollisionShape2D` y `ColorRect`.
3. Instanciar al `Personaje` sobre una de las plataformas.
4. Añadir un `CanvasLayer` con un `Panel` que muestre:
   * Etiqueta de estado del Buffer de Entrada.
   * Barra de progreso (`ProgressBar`) vinculada a `temporizador_buffer`.
   * Etiqueta de estado del Coyote Time.
   * Barra de progreso (`ProgressBar`) vinculada a `temporizador_coyote`.
   * Indicador del estado del personaje (*EN EL SUELO* / *EN EL AIRE*).
   * Leyenda de controles.

---

### Paso 4: Dinámica de la Explicación y Demostración en Vivo (2 minutos)

1. **Ejecutar la escena (`F5`)**:
   * Mostrar cómo al saltar hacia una plataforma y presionar `Espacio` **un instante antes de tocar el suelo**, el personaje salta en el milisegundo exacto de hacer contacto.
   * Señalar la barra verde del buffer en el panel: se llena y se consume al aterrizar.
2. **Desactivar el Buffer de Entrada (presionar tecla `B`)**:
   * Saltar y presionar `Espacio` justo antes de aterrizar.
   * **Resultado visible**: El personaje "se traba" o aterriza en seco sin saltar, provocando frustración en el jugador (el problema que resuelve).
3. **Reactivar el Buffer (`B`) y demostrar Coyote Time (`C`)**:
   * Caminar hacia el borde de una plataforma y presionar salto **justo después de caer al vacío**.
   * Se aprecia cómo el Coyote Time permite salvar la caída, trabajando en perfecta armonía con el buffer.
