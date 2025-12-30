# ♟️ Reloj de Ajedrez Profesional en FPGA – DE10-Lite (VHDL)

Proyecto desarrollado para el curso **1IEE04 – Diseño Digital** de la  
**Pontificia Universidad Católica del Perú (PUCP)**.

El sistema implementa un **reloj de ajedrez profesional**, basado en el **DGT 2010**, utilizando una arquitectura jerárquica sobre FPGA **Intel DE10-Lite**, programado en **VHDL**.

---
### Autor

**Moisés Ariel Challco Meza**  
Estudiante de Ingeniería Electrónica – PUCP  
Curso: 1IEE04 – Diseño Digital

---

## Descripción general

El circuito  principal `reloj_ajedrez` permite controlar el tiempo de dos jugadores de ajedrez, mostrando el tiempo de forma **descendente**, gestionando múltiples **modos de juego**, contabilizando **movimientos**, y determinando automáticamente la **pérdida por tiempo**, incluyendo señalización visual mediante LEDs.

Todo el sistema está gobernado por una **máquina de estados finitos (fms.vhd)** y opera de manera síncrona a partir de un reloj de **50 MHz**.

---

## ⚙️ Especificaciones del sistema

### 🔌 Entradas
| Señal | Descripción |
|-----|------------|
| `clk` | Reloj del sistema de 50 MHz (flanco de subida) |
| `reset_n` | Reset asíncrono activo en bajo |
| `config` | Habilita la configuración del modo de juego |
| `ini_pausa` | Inicia o pausa el conteo de tiempo |
| `jugador_act` | Selecciona el jugador activo (0 o 1) |
| `modo[1:0]` | Selección del modo de juego |
| `ver_disp[1:0]` | Selección de información a visualizar |

---

### 🕹️ Modos de juego
| Código | Modo |
|----|----|
| `00` | Blitz – 5 minutos por jugador |
| `01` | Rapid – 25 minutos por jugador |
| `10` | World Chess Championship Match (FIDE 1996) |
| `11` | Manual (tiempo definido por parámetros) |

#### Modo World Chess Championship Match
- 2 horas para los primeros **40 movimientos**
- Luego, **1 hora por cada bloque de 16 movimientos**
- Si el jugador no alcanza el mínimo de movimientos en el tiempo asignado, **pierde la partida**

---

### Salidas
| Señal | Descripción |
|-----|------------|
| `display_0` | Unidades de segundo |
| `display_1` | Decenas de segundo |
| `display_2` | Unidades de minuto |
| `display_3` | Decenas de minuto |
| `display_4` | Unidades de hora |
| `leds[9:0]` | Indicador visual de pérdida por tiempo |

📌 Todos los displays trabajan en **formato decimal (BCD)**.

---

## Funcionamiento general

1. El sistema inicia en reset (`reset_n = 0`), con displays apagados.
2. Se habilita configuración (`config = 1`) y se selecciona el modo.
3. Se bloquea la configuración (`config = 0`).
4. Se selecciona el jugador inicial.
5. El tiempo decrementa únicamente para el jugador activo.
6. El juego puede pausarse con `ini_pausa = 0`.
7. El primer jugador que consume todo su tiempo **pierde automáticamente**.

---

## Señalización de derrota (LEDs)

- **Jugador 0 pierde**  
  - LEDs [9:5]: secuencia `10101 → 01010 → 10101` (cada 1 s)  
  - LEDs [4:0]: `00000`

- **Jugador 1 pierde**  
  - LEDs [9:5]: `00000`  
  - LEDs [4:0]: secuencia intermitente

Esta lógica se implementa mediante un generador síncrono a 1 Hz.

---

## 🧠 Arquitectura de diseño digital

El sistema está organizado de forma **modular**, separando claramente funciones de control, conteo, visualización y señalización.

### 📂 Archivos VHDL

| Archivo | Función |
|------|--------|
| `reloj_ajedrez.vhd` | Módulo top del sistema |
| `fsm.vhd` | Máquina de estados finitos principal |
| `selector_modo.vhd` | Gestión y bloqueo del modo de juego |
| `divisor_freq.vhd` | División de reloj (50 MHz → 1 Hz) |
| `reloj.vhd` | Control general del conteo de tiempo, para cada jugador |
| `counter_mod.vhd` | Contador parametrizable descendente |
| `counter_horas.vhd` | Contador exclusivo de horas |
| `contador_asc.vhd` | Conteo ascendente de movimientos |
| `comparador.vhd` | Comparación de límites de tiempo/movimientos |
| `bintobcd.vhd` | Conversión binario a BCD |
| `bintobcd_12.vhd` | Conversión binaria de 12 bits a BCD |
| `hexa.vhd` | BCD a 7 segmentos |
| `Mux4a1.vhd` | Multiplexor de visualización para ver_disp |
| `reg_d.vhd` | Registros síncronos |
| `generador_leds.vhd` | Generación de patrones de LEDs |
| `my_components.vhd` | Declaración de componentes |

---

## Observación: FSM
El control del reloj de ajedrez se implementa mediante una máquina de estados finitos (FSM) descrita en fsm.vhd, la cual gobierna la configuración del sistema, el conteo de tiempo, el cambio de turno entre jugadores y la detección de pérdida por tiempo.

La FSM es síncrona, opera con el reloj de 50 MHz y posee reset asíncrono activo en bajo.

Los principales estados que conforman la FSM son:

- ST_IDLE: estado inicial tras el reset, con el sistema inactivo

- ST_WAIT_CONFIG: habilita la configuración del modo de juego

- ST_PLAYERS_CONFIG: preparación de la partida y selección del jugador inicial

- ST_PLAYER_0 / ST_PLAYER_1: conteo activo del tiempo del jugador correspondiente

- ST_PLAYER_0_P / ST_PLAYER_1_P: pausa del conteo para cada jugador

- ST_PLAYER_0_M / ST_PLAYER_1_M: transición de cambio de turno entre jugadores

- ST_PLAYER_0_L / ST_PLAYER_1_L: estado final de pérdida por tiempo

A partir de estos estados, la FSM genera las señales de control que habilitan o pausan los contadores de tiempo y movimientos, actuando como la unidad de control central del sistema y garantizando un comportamiento determinista y verificable.

