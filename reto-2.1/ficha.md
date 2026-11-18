# Ficha Técnica del Dispositivo: Teclado

## 1. Dispositivo Seleccionado
**Teclado (Keyboard)**

---

## 2. Tecnología de Captura
El teclado captura las acciones del usuario mediante una matriz de interruptores eléctricos organizados en filas y columnas sobre una placa de circuito impreso o láminas de membrana flexible. 

Al presionar una tecla, el vástago o la cúpula de goma empuja un contacto conductor que cierra el circuito eléctrico en las coordenadas específicas de esa intersección (fila y columna). Un microcontrolador interno escanea continuamente la matriz a alta frecuencia (multiplexación matricial); al detectar el cambio de voltaje producido por el cierre del contacto, procesa el evento, aplica filtros anti-rebote (*debouncing*) y genera un código de escaneo unívoco (*scancode* o *key code*). Finalmente, este paquete de datos binarios se transmite al computador a través del controlador USB o protocolo correspondiente, generando una interrupción en el sistema operativo para que el motor de videojuegos (Godot) lo procese mediante `InputEventKey`.

---

## 3. Tipo de Señal y Justificación
- **Tipo de señal:** **Digital**
- **Frase de justificación:** *Es una señal de tipo digital porque opera únicamente mediante estados discretos y binarios (0 o 1, circuito abierto o circuito cerrado, tecla pulsada o liberada), sin registrar niveles graduales, continuos ni intensidades intermedias de presión física.*

---

## 4. Ventaja
Ofrece una **precisión binaria inmediata y consistente** para la activación de comandos discretos. No depende de calibración de ejes ni sufre de desviaciones por desgaste (*stick drift*) o zonas muertas (*deadzones*), lo que garantiza tiempos de respuesta mínimos y exactitud predecible en cada pulsación.

---

## 5. Limitación
**Ausencia de modulación analógica o gradual de entrada**. Dado que cada tecla solo puede estar completamente activada o completamente inactiva, no permite graduar con naturalidad la velocidad de marcha de un personaje o el grado de aceleración/giro de un vehículo, obligando al usuario a realizar pulsaciones intermitentes (micro-toques) o al desarrollador a programar aceleraciones y desaceleraciones simuladas por software.

---

## 6. Juego Ejemplo
**Celeste** (*Maddy Makes Games*)  
En títulos de plataformas de alta precisión como *Celeste*, el teclado resulta una herramienta óptima debido a que el desplazamiento, el agarre y los impulsos (*dashes*) se fundamentan en decisiones binarias y direcciones cardinales u ordinales exactas (8 direcciones). La inmediatez de la señal digital permite realizar secuencias de movimientos en cuadros exactos (*frame-perfect*) con una confiabilidad superior a la de un eje analógico.

---

## 7. Fuente con Enlace
- **Godot Engine Documentation - Class InputEventKey:**  
  [https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html](https://docs.godotengine.org/en/stable/classes/class_inputeventkey.html)
- **Tecnología del Teclado de Computadora - Wikipedia:**  
  [https://es.wikipedia.org/wiki/Teclado_(inform%C3%A1tica)](https://es.wikipedia.org/wiki/Teclado_(inform%C3%A1tica))
