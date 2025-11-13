# Alexa Assistant - Roblox

Un asistente virtual completo como Alexa para Roblox con interfaz gráfica, reconocimiento de voz simulado y modelo 3D interactivo.

## Características

### 🎤 Interfaz de Usuario
- **Dispositivo Alexa Visual**: Cilindro con anillo LED animado
- **Chat Interactivo**: Conversación en tiempo real
- **Controles de Voz**: Botón de micrófono y entrada de texto
- **Animaciones LED**: Diferentes colores según el estado
- **Pantalla de Estado**: Muestra el estado actual de Alexa

### 🧠 Inteligencia Artificial
- **Base de Conocimiento**: Respuestas a preguntas comunes
- **Reconocimiento de Patrones**: Entiende diferentes formas de preguntar
- **Respuestas Contextuales**: Adapta respuestas según el tema
- **Comandos Especiales**: Chistes, información, matemáticas

### 🎮 Modelo 3D Interactivo
- **Dispositivo Físico**: Alexa 3D en el mundo del juego
- **Animaciones Realistas**: LED que cambia de color
- **Interacción Directa**: Click para activar
- **Efectos Visuales**: Luces y animaciones suaves

## Comandos Disponibles

### Saludos
- "Hola", "Buenos días", "Buenas tardes"

### Información Personal
- "¿Cómo te llamas?", "¿Quién eres?", "¿Qué puedes hacer?"

### Entretenimiento
- "Cuenta un chiste", "Canta una canción", "Cuéntame un cuento"

### Información General
- "Capital de España", "¿Qué es Roblox?"

### Matemáticas
- "¿Cuánto es 2 más 2?", "5 por 3", "10 menos 4"

### Control
- "Ayuda", "Gracias", "Adiós"

## Estructura del Proyecto

```
AlexaAssistant/
├── src/
│   ├── client/
│   │   └── AlexaUI.lua           # Interfaz principal
│   ├── server/
│   │   └── AlexaServer.lua       # Lógica y respuestas
│   └── workspace/
│       └── AlexaDevice.lua       # Modelo 3D
├── default.project.json
└── README.md
```

## Instalación

### Opción 1: Rojo
1. Instala Rojo desde https://rojo.space/
2. Ejecuta `rojo serve` en la carpeta AlexaAssistant
3. Conecta desde Roblox Studio

### Opción 2: Manual
1. **ServerScriptService**: Copia `AlexaServer.lua`
2. **StarterPlayerScripts**: Copia `AlexaUI.lua`
3. **Workspace**: Copia `AlexaDevice.lua`

## Uso

1. **Abrir Interfaz**: Se abre automáticamente al entrar
2. **Hablar con Alexa**: Escribe en el chat o usa el botón de micrófono
3. **Interactuar con el Modelo 3D**: Click en el dispositivo físico
4. **Ver Respuestas**: Las respuestas aparecen en el chat

## Características Técnicas

### Animaciones LED
- **Azul**: Estado inactivo
- **Rojo**: Escuchando
- **Naranja**: Procesando
- **Verde**: Hablando

### Sistema de Chat
- **Mensajes del Usuario**: Fondo azul
- **Respuestas de Alexa**: Fondo gris
- **Scroll Automático**: Se desplaza a mensajes nuevos

### Reconocimiento de Voz
- **Simulado**: Botón de micrófono activa escucha
- **Visual**: Animaciones durante la "escucha"
- **Tiempo Real**: Respuestas inmediatas

## Personalización

El asistente es completamente personalizable:
- Agregar nuevos comandos en `alexaKnowledge`
- Modificar respuestas por defecto
- Cambiar colores y animaciones
- Añadir nuevos sonidos y efectos