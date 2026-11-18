# Respuestas al Cuestionario del Reto

---

### Pregunta 1
**Mantén `D` dos segundos y suéltala: ¿qué contador subió más y por qué?**

**Respuesta:**  
El contador que subió significativamente más fue el de **cuadros con la acción pulsada (sondeo / polling)**, alcanzando aproximadamente **120 cuadros** (a una tasa estándar de 60 cuadros por segundo durante los 2 segundos transcurridos). Por el contrario, el contador de **eventos recibidos (`_input`)** únicamente se incrementó en **1** (o 1 por la pulsación inicial).

**Justificación técnica:**
1. **Sondeo (Polling en `_physics_process`):** La consulta `Input.is_action_pressed("move_right")` evalúa el estado del dispositivo en cada ciclo o fotograma del motor de juego. Mientras la tecla `D` se mantenga presionada físicamente, la condición se cumple en cada frame, acumulando un incremento continuo por cuadro ejecutado.
2. **Eventos (`_input(event)`):** El sistema de eventos se basa en interrupciones o notificaciones de cambio de estado enviadas por el sistema operativo. Cuando el usuario presiona la tecla `D`, se despacha un único evento de tipo `InputEventKey` con `pressed = true`. Dado que en el código se filtra e ignora explícitamente el eco del teclado (`event.is_echo()`), las señales repetitivas generadas por el sistema operativo durante la pulsación continua son descartadas, resultando en un único incremento al registrar el cambio inicial de estado.

---

### Pregunta 2
**Mantén `A`: ¿qué valor muestran `get_axis` y `get_action_strength("move_right")`, y por qué difieren?**

**Respuesta:**
- `get_axis("move_left", "move_right")` muestra un valor de **`-1.00`**.
- `get_action_strength("move_right")` muestra un valor de **`0.00`**.

**Justificación técnica:**  
Difieren porque cada método responde a un propósito y cálculo diferente dentro del sistema de entradas de Godot:
1. **`Input.get_axis(accion_negativa, accion_positiva)`:** Es una función compuesta que evalúa un eje bidireccional mediante la fórmula matemática `fuerza_positivo - fuerza_negativo`. Al mantener pulsada la tecla `A`, se activa la acción negativa (`move_left`) con intensidad `1.0`, mientras que la positiva (`move_right`) permanece en `0.0`. Por tanto, el cálculo resulta en `0.0 - 1.0 = -1.00`, indicando un desplazamiento total hacia el extremo negativo del eje (hacia la izquierda).
2. **`Input.get_action_strength("move_right")`:** Es una consulta individual que devuelve exclusivamente la magnitud o fuerza de activación de una sola acción específica (un escalar normalizado entre `0.0` y `1.0`). Dado que la tecla `A` únicamente acciona `move_left` y la tecla `D` no está siendo presionada en absoluto, la intensidad de `move_right` es estrictamente `0.00`.

---

### Pregunta 3
**Gira la rueda del ratón: ¿qué clase de evento aparece y por qué su rama va antes que la del clic?**

**Respuesta:**
- **Clase de evento que aparece:** **`InputEventMouseButton`** (tanto el scroll de la rueda como los clics corresponden a la clase nativa `InputEventMouseButton` en Godot).

**¿Por qué su rama va antes que la del clic en el código?**  
1. **Pertenencia a la misma clase:** En Godot Engine, los desplazamientos de la rueda del ratón no constituyen una clase separada, sino que se mapean internamente como botones específicos (`MOUSE_BUTTON_WHEEL_UP`, `MOUSE_BUTTON_WHEEL_DOWN`, `MOUSE_BUTTON_WHEEL_LEFT`, `MOUSE_BUTTON_WHEEL_RIGHT`) dentro de la misma clase `InputEventMouseButton` que contiene a los botones de clic ordinarios (`MOUSE_BUTTON_LEFT`, `MOUSE_BUTTON_RIGHT`, `MOUSE_BUTTON_MIDDLE`).
2. **Discriminación lógica y precedencia condicional:** Al estar bajo la misma jerarquía de clase, si no se comprueban primero los índices de los botones correspondientes a la rueda de desplazamiento, un bloque condicional general de botones o una rama por defecto (`else` para clics) procesaría las señales de la rueda erróneamente como clics ordinarios.
3. **Naturaleza del evento:** A diferencia de un botón de clic físico convencional que puede permanecer en estado presionado sostenido en el tiempo (`pressed = true` durante varios frames), la rueda del ratón emite un impulso discreto y prácticamente instantáneo de pulsado y liberado en la misma unidad de tiempo para representar un "paso" o desplazamiento. Colocar su evaluación antes en la estructura `if...elif...else` asegura que se capture y clasifique específicamente como desplazamiento discreto antes de interactuar con la lógica estándar de pulsaciones sostenidas o liberaciones de botones de clic.
