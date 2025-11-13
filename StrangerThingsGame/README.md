# Stranger Things: Upside Down - Juego de Roblox

## 🎮 Descripción
Juego completo de exploración del Upside Down de Stranger Things (Temporada 4) para Roblox. Incluye atmósfera tenebrosa, efectos visuales detallados, y los poderes de Eleven.

## 🌌 Características del Upside Down

### Atmósfera
- **Iluminación oscura** con tonos azul-gris
- **Niebla densa** que limita la visibilidad
- **Efectos atmosféricos** con partículas flotantes
- **Relámpagos rojos** aleatorios que iluminan el cielo

### Elementos del Mundo
- **Suelo orgánico** con textura deteriorada y partículas
- **Lianas colgantes** (50+) con animación de balanceo y esporas
- **Edificios deteriorados** (10+) cubiertos de vegetación
- **Membranas orgánicas** pulsantes en paredes
- **Tentáculos animados** (15+) con movimiento ondulante
- **Grietas en el suelo** (30+) con luz roja emanando
- **Paredes orgánicas** (15+) con venas pulsantes
- **Nidos orgánicos** (12+) emitiendo esporas
- **Rocas flotantes** (25+) con movimiento suave
- **Esporas flotantes** (100+) con movimiento aleatorio

### Portal de Teletransporte
- **Portal dimensional** con efectos de partículas y luz
- **Teletransporte bidireccional** entre mundo normal y Upside Down
- **Efectos visuales** al atravesar el portal
- **Animación de rotación** constante

## ⚡ Poderes de Eleven

### 1. Telequinesis (Tecla Q)
- Empuja objetos en el área objetivo
- Efecto visual de energía púrpura
- Partículas de poder
- Cooldown: 3 segundos

### 2. Onda Mental (Tecla E)
- Onda expansiva que empuja todo alrededor
- Efecto de cámara (FOV)
- Partículas rosadas
- Cooldown: 5 segundos

### 3. Levitación (Tecla R)
- Levita al jugador 10 studs
- Efecto visual circular debajo
- Duración: 3 segundos
- Cooldown: 4 segundos

### Efectos de Poderes
- **Sangrado de nariz** (partículas rojas)
- **Aura de energía** púrpura alrededor del jugador
- **Shake de cámara** al usar poderes
- **Partículas de energía** siguiendo al jugador

## 🎨 Efectos Visuales

### Efectos de Cámara
- **Aberración cromática** con blur sutil
- **Viñeta oscura** pulsante
- **Líneas de interferencia** aleatorias
- **Partículas en cámara** para inmersión
- **Shake constante** muy sutil

### Efectos de Iluminación
- **Luces puntuales** en portales, grietas y nidos
- **Luces pulsantes** en elementos orgánicos
- **Flash de relámpagos** rojos periódicos
- **Bloom effect** para luces brillantes

### Partículas
- **Esporas flotantes** en el aire
- **Humo de grietas** emanando del suelo
- **Gotas de humedad** de tentáculos
- **Polvo de rocas** flotantes
- **Energía de poderes** al usar habilidades

## 📁 Estructura del Proyecto

```
StrangerThingsGame/
├── src/
│   ├── ServerScriptService/
│   │   ├── MainServer.lua          # Script principal del servidor
│   │   ├── SporeSystem.lua         # Sistema de esporas flotantes
│   │   ├── TentacleSystem.lua      # Sistema de tentáculos animados
│   │   ├── CracksAndDecay.lua      # Grietas, deterioro y elementos orgánicos
│   │   └── LightningSystem.lua     # Sistema de relámpagos rojos
│   └── StarterPlayer/
│       └── StarterPlayerScripts/
│           ├── ClientController.lua # Controlador del cliente y poderes
│           └── CameraEffects.lua    # Efectos visuales de cámara
└── README.md
```

## 🎯 Controles

### Teclado
- **Q** - Telequinesis (apunta con el mouse)
- **E** - Onda Mental
- **R** - Levitación
- **WASD** - Movimiento
- **Espacio** - Saltar
- **Shift** - Correr

### GUI
- Botones en pantalla para activar poderes
- Panel de poderes en la esquina inferior derecha

## 🚀 Instalación en Roblox Studio

1. Abre Roblox Studio
2. Crea un nuevo lugar o abre uno existente
3. Copia los scripts a las carpetas correspondientes:
   - Scripts de `ServerScriptService/` → ServerScriptService
   - Scripts de `StarterPlayer/StarterPlayerScripts/` → StarterPlayer > StarterPlayerScripts
4. Presiona Play para probar el juego

## 🎬 Detalles de la Temporada 4

El diseño está basado en la representación del Upside Down de la temporada 4:
- Atmósfera más oscura y tenebrosa
- Mayor presencia de elementos orgánicos
- Venas y membranas pulsantes
- Esporas flotantes densas
- Relámpagos rojos característicos
- Deterioro extremo de estructuras

## 🔧 Personalización

Puedes ajustar los siguientes parámetros en los scripts:

### MainServer.lua
- Cantidad de lianas: línea 318 (actualmente 50)
- Cantidad de edificios: línea 326 (actualmente 10)
- Cantidad de membranas: línea 337 (actualmente 20)

### SporeSystem.lua
- Cantidad de esporas: línea 48 (actualmente 100)

### TentacleSystem.lua
- Cantidad de tentáculos: línea 95 (actualmente 15)

### CracksAndDecay.lua
- Cantidad de grietas: línea 186 (actualmente 30)
- Cantidad de paredes: línea 197 (actualmente 15)
- Cantidad de nidos: línea 209 (actualmente 12)
- Cantidad de rocas: línea 220 (actualmente 25)

### LightningSystem.lua
- Frecuencia de relámpagos: línea 95 (10-25 segundos)

## 🎮 Modo de Juego

Este es un juego de **exploración libre** sin objetivos ni tareas. Los jugadores pueden:
- Explorar el mundo del Upside Down
- Experimentar con los poderes de Eleven
- Descubrir todos los detalles visuales
- Atravesar portales entre dimensiones
- Disfrutar de la atmósfera inmersiva

## 💡 Características Técnicas

- **Sistema de partículas** avanzado para efectos atmosféricos
- **TweenService** para animaciones suaves
- **Sistema de física** para tentáculos y objetos
- **Iluminación dinámica** con efectos pulsantes
- **Eventos remotos** para comunicación cliente-servidor
- **GUI personalizada** para controles de poderes

## 🌟 Efectos Especiales

- Todos los elementos orgánicos tienen animaciones
- Las partículas se generan proceduralmente
- Los relámpagos son completamente aleatorios
- La cámara tiene efectos de inmersión constantes
- Los poderes tienen feedback visual y de cámara

---

**Creado para una experiencia inmersiva del Upside Down de Stranger Things en Roblox** 🎮✨
