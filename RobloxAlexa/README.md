# 🎤 Roblox Alexa Assistant

Asistente virtual tipo Alexa completamente funcional para Roblox con reconocimiento de comandos de texto y animaciones.

## ✨ Características

### Dispositivo Alexa 3D
- **Diseño cilíndrico** realista tipo Amazon Echo
- **Anillo de luz** animado que cambia de color
- **Animaciones de respiración** y rotación sutil
- **Partículas de sonido** cuando está activa
- **Botones físicos** interactivos en la parte superior
- **Logo iluminado** con emoji de micrófono

### Sistema de Comandos
Alexa puede responder a:
- ✅ **Saludos**: "hola", "como estas"
- ✅ **Información**: "que hora es", "clima"
- ✅ **Entretenimiento**: "cuentame un chiste", "reproduce musica"
- ✅ **Control de luces**: "apaga las luces", "enciende las luces"
- ✅ **Acciones**: "baila"
- ✅ **Ayuda**: "ayuda", "cual es tu nombre"
- ✅ **Despedidas**: "adios", "gracias"

### Interfaz de Usuario
- **Botón flotante** animado para abrir Alexa
- **Panel principal** con diseño moderno
- **Indicador de escucha** con animación de pulso
- **Campo de texto** para escribir comandos
- **Respuestas animadas** que aparecen desde abajo
- **Efectos visuales** suaves y profesionales

### Animaciones del Dispositivo
- **Anillo de luz azul** cuando está escuchando
- **Anillo verde** en estado de espera
- **Pulso de transparencia** constante
- **Rotación sutil** del dispositivo
- **Baile** cuando se le pide
- **Cambio de iluminación** del juego según comandos

## 📁 Estructura del Proyecto

```
RobloxAlexa/
├── src/
│   ├── ServerScriptService/
│   │   └── AlexaServer.lua          # Servidor + Dispositivo virtual
│   └── StarterPlayer/
│       └── StarterPlayerScripts/
│           └── AlexaClient.lua      # UI y cliente
└── README.md
```

## 🎮 Cómo Usar

### Para Jugadores
1. Haz clic en el **botón flotante azul** (🎤) en la esquina inferior derecha
2. Escribe tu comando en el campo de texto
3. Presiona **ENVIAR** o **Enter**
4. Alexa responderá con texto animado

### Comandos de Ejemplo
```
"Hola Alexa"
"¿Qué hora es?"
"Cuéntame un chiste"
"Apaga las luces"
"Baila"
"Ayuda"
```

## 🚀 Instalación en Roblox Studio

1. Abre Roblox Studio
2. Crea un nuevo lugar
3. Copia los scripts a las carpetas correspondientes:
   - `AlexaServer.lua` → ServerScriptService
   - `AlexaClient.lua` → StarterPlayer > StarterPlayerScripts
4. Presiona Play (el dispositivo se crea automáticamente)

## 🎨 Personalización

### Agregar Nuevos Comandos
En `AlexaServer.lua`, edita el diccionario `commands`:

```lua
local commands = {
    ["tu comando"] = "Respuesta de Alexa",
    ["otro comando"] = function() 
        return "Respuesta dinámica"
    end
}
```

### Cambiar Colores
En `CreateAlexaDevice.lua`:
- **Anillo de luz**: `lightRing.Color`
- **Base**: `base.Color`
- **Logo**: `logo.Color`

### Modificar Animaciones
En `AlexaClient.lua`:
- **Velocidad de pulso**: `TweenInfo.new(1, ...)` → cambiar el 1
- **Tamaño del panel**: `mainFrame.Size`

## 🔧 Características Técnicas

### Servidor
- Procesamiento de comandos con pattern matching
- Ejecución de acciones en el juego (luces, animaciones)
- Sistema de respuestas dinámicas
- Animación del dispositivo físico

### Cliente
- UI responsiva con TweenService
- Animaciones suaves de entrada/salida
- Indicador visual de estado
- Botón flotante siempre accesible

### Dispositivo Virtual
- Se crea automáticamente al iniciar
- Modelo 3D procedural
- Animaciones de luz pulsante
- Iluminación dinámica

## 💡 Efectos Visuales

### Anillo de Luz
- **Azul pulsante**: Escuchando comando
- **Verde suave**: En espera
- **Animación continua**: Respiración

### UI
- **Aparición**: Efecto Back ease
- **Respuestas**: Deslizamiento desde abajo
- **Botón**: Cambio de color cíclico
- **Pulso**: Indicador de actividad

### Dispositivo
- **Rotación**: 0.5° por frame
- **Partículas**: Sparkles azules
- **Luz ambiental**: 20 studs de rango
- **Baile**: Rotación de 15° cuando se activa

## 🎯 Comandos Especiales

### Control de Iluminación
- **"Apaga las luces"**: Brightness = 0, ambiente oscuro
- **"Enciende las luces"**: Brightness = 2, ambiente claro

### Animaciones
- **"Baila"**: El dispositivo hace una animación de rebote

### Información
- **"Que hora es"**: Muestra hora actual del sistema
- **"Clima"**: Respuesta predefinida

## 🌟 Futuras Mejoras Posibles

- Integración con Roblox Voice Chat
- Más comandos y respuestas
- Sistema de música real
- Control de más elementos del juego
- Personalización de voz
- Historial de comandos
- Múltiples idiomas

---

**Creado para Roblox** 🎮✨
