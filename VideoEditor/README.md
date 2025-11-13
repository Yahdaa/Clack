# Video Editor - Roblox

Un editor de video completo estilo CapCut para Roblox con interfaz profesional y funcionalidades avanzadas.

## Características

### Interfaz de Usuario
- **Diseño Responsive**: Se adapta perfectamente a cualquier tamaño de pantalla
- **Barra Superior**: Botones de importar, guardar y exportar
- **Panel Izquierdo**: Herramientas de edición (cortar, texto, efectos, etc.)
- **Área Central**: Preview del video con controles de reproducción
- **Panel Derecho**: Propiedades y configuraciones
- **Timeline Inferior**: Tracks de video, audio y texto con clips arrastrables

### Herramientas Disponibles
- ✂ **Cut**: Cortar clips
- ⚡ **Trim**: Recortar duración
- T **Text**: Agregar texto
- ♪ **Music**: Agregar música
- ✨ **Effects**: Efectos visuales
- 🎨 **Filters**: Filtros de color
- ⚡ **Speed**: Cambiar velocidad
- → **Transition**: Transiciones

### Funcionalidades
- **Reproducción**: Play/pause con barra de progreso
- **Timeline Interactivo**: Clips arrastrables en múltiples tracks
- **Guardado de Proyectos**: Sistema de persistencia
- **Exportación**: Múltiples formatos y calidades
- **Propiedades**: Panel de configuración en tiempo real

## Estructura del Proyecto

```
VideoEditor/
├── src/
│   ├── client/
│   │   ├── VideoEditorUI.lua      # Interfaz principal
│   │   └── VideoEditorLogic.lua   # Lógica y funcionalidad
│   ├── server/
│   │   └── VideoEditorServer.lua  # Servidor y datos
│   └── shared/
├── default.project.json           # Configuración Rojo
└── README.md
```

## Instalación

1. Instala [Rojo](https://rojo.space/)
2. Ejecuta `rojo serve` en la carpeta del proyecto
3. Conecta desde Roblox Studio usando el plugin de Rojo
4. La interfaz se carga automáticamente al entrar al juego

## Uso

1. **Importar**: Usa el botón "Import" para cargar videos
2. **Editar**: Selecciona herramientas del panel izquierdo
3. **Timeline**: Arrastra clips para reorganizar
4. **Preview**: Usa los controles de reproducción
5. **Exportar**: Guarda tu video terminado

## Características Técnicas

- **UI Responsive**: Usa UDim2 para escalado perfecto
- **Animaciones Suaves**: TweenService para transiciones
- **Drag & Drop**: Clips completamente interactivos
- **Modular**: Código organizado y extensible
- **Performance**: Optimizado para Roblox

## Personalización

El editor es completamente personalizable:
- Colores y temas
- Herramientas adicionales
- Formatos de exportación
- Efectos y filtros personalizados