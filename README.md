# 📱 Sistema de App Store para Roblox

Sistema completo de App Store dentro de Roblox donde los jugadores pueden crear, publicar y jugar aplicaciones (minijuegos) creadas por otros usuarios.

## 🎮 Características Principales

### ✨ Para Jugadores
- **Explorar App Store**: Navega por todas las apps publicadas
- **Jugar Apps**: Entra y juega las creaciones de otros usuarios
- **Dar Likes**: Apoya tus apps favoritas
- **Ver Estadísticas**: Visitas y likes de cada app

### 🛠️ Para Creadores
- **Crear Apps**: Sistema completo de creación de aplicaciones
- **Editor Visual**: Coloca objetos, plataformas, obstáculos
- **Personalización**: Elige nombre, descripción y color de miniatura
- **Publicación Instantánea**: Publica y edita en tiempo real
- **Gestión**: Solo tú puedes editar tus propias apps

## 📋 Instalación en Roblox Studio

### Paso 1: Preparar el Proyecto
1. Abre **Roblox Studio**
2. Crea un nuevo lugar o abre uno existente
3. Asegúrate de habilitar **API Services** en Game Settings

### Paso 2: Habilitar DataStore
1. Ve a **Home** → **Game Settings**
2. En la pestaña **Security**
3. Activa **Enable Studio Access to API Services**
4. Guarda los cambios

### Paso 3: Instalar Server Script
1. En el **Explorer**, busca **ServerScriptService**
2. Clic derecho → **Insert Object** → **Script**
3. Renombra a "AppStoreServer"
4. Abre el archivo `ServerScriptService/AppStoreServer.lua`
5. Copia TODO el código (Ctrl+A, Ctrl+C)
6. Pégalo en el script de Roblox Studio (Ctrl+V)

### Paso 4: Instalar Local Script
1. En el **Explorer**, busca **StarterPlayer** → **StarterPlayerScripts**
2. Clic derecho en StarterPlayerScripts → **Insert Object** → **LocalScript**
3. Renombra a "AppStoreClient"
4. Abre el archivo `StarterPlayer/StarterPlayerScripts/AppStoreClient.lua`
5. Copia TODO el código (Ctrl+A, Ctrl+C)
6. Pégalo en el LocalScript de Roblox Studio (Ctrl+V)

### Paso 5: Probar el Juego
1. Presiona **F5** o clic en **Play** (▶)
2. Verás la App Store con la interfaz principal
3. Haz clic en **"+ Crear App"** para empezar

## 🎯 Cómo Usar

### Crear una App
1. Clic en **"+ Crear App"** en la esquina superior derecha
2. Ingresa el **nombre** de tu app
3. Escribe una **descripción**
4. Selecciona un **color** para la miniatura
5. Clic en **"Publicar y Editar"**

### Editar tu App
1. Se abrirá el **Editor** automáticamente
2. Usa el panel lateral para agregar objetos:
   - **Plataforma**: Base para caminar
   - **Obstáculo**: Bloques rojos
   - **Muro**: Paredes altas
   - **Rampa**: Plataformas inclinadas
3. Los objetos aparecen frente a ti
4. Clic en **"💾 Guardar"** para guardar cambios
5. Clic en **"🚪 Salir"** para volver a la App Store

### Jugar Apps de Otros
1. En la App Store, busca una app que te guste
2. Clic en **"▶ Jugar"**
3. Serás teletransportado al mundo de esa app
4. Explora y juega
5. Clic en **"🏠 Salir"** para regresar

## 🏗️ Arquitectura del Sistema

### Servidor (AppStoreServer.lua)
- **DataStore**: Almacenamiento persistente de apps
- **RemoteEvents**: Comunicación cliente-servidor
- **Gestión de Mundos**: Crea instancias de apps
- **Sistema de Visitas**: Contador automático
- **Sistema de Likes**: Gestión de popularidad

### Cliente (AppStoreClient.lua)
- **UI Principal**: Interfaz de App Store
- **Sistema de Creación**: Panel de nueva app
- **Editor Visual**: Herramientas de construcción
- **Navegación**: Teletransporte entre mundos

## 📊 Estructura de Datos

Cada app se guarda con:
```lua
{
    Id = "UserId_timestamp",
    Name = "Nombre de la App",
    Description = "Descripción",
    Creator = "NombreUsuario",
    CreatorId = UserId,
    ThumbnailColor = {R, G, B},
    Visits = 0,
    Likes = 0,
    Objects = {
        {
            SizeX, SizeY, SizeZ,
            PosX, PosY, PosZ,
            RotX, RotY, RotZ,
            Color = "BrickColor",
            Material = "Material"
        }
    }
}
```

## 🎨 Objetos Disponibles en el Editor

| Objeto | Tamaño | Color | Uso |
|--------|--------|-------|-----|
| Plataforma | 10x1x10 | Verde | Base para caminar |
| Obstáculo | 4x4x4 | Rojo | Bloques de desafío |
| Muro | 10x8x1 | Gris | Paredes y límites |
| Rampa | 8x1x10 | Amarillo | Plataformas elevadas |

## 🔧 Personalización

### Agregar Más Objetos
En `AppStoreClient.lua`, busca la tabla `objects` en la función `openEditor`:

```lua
local objects = {
    {Name = "Plataforma", Size = Vector3.new(10, 1, 10), Color = "Bright green"},
    {Name = "TuObjeto", Size = Vector3.new(X, Y, Z), Color = "Color"},
    -- Agrega más aquí
}
```

### Cambiar Colores de Miniatura
En `openCreateAppUI`, modifica la tabla `colors`:

```lua
local colors = {
    {R, G, B},  -- Agrega más colores RGB
}
```

### Modificar Tamaño del Mundo
En `AppStoreServer.lua`, busca `createBaseplate`:

```lua
local baseplate = Instance.new("Part")
baseplate.Size = Vector3.new(100, 1, 100)  -- Cambia el tamaño
```

## 🚀 Características Avanzadas

### Sistema de Persistencia
- Usa **DataStoreService** de Roblox
- Guarda automáticamente al publicar
- Carga apps al iniciar el juego

### Instanciación de Mundos
- Cada app tiene su propio espacio
- Posiciones aleatorias para evitar colisiones
- Spawn points automáticos

### Seguridad
- Solo el creador puede editar su app
- Validación de permisos en servidor
- Protección contra exploits

## 📝 Solución de Problemas

### Las apps no se guardan
- Verifica que **API Services** esté habilitado
- Revisa la consola de Output para errores
- Asegúrate de estar en modo Play, no en modo Edit

### No aparece la UI
- Confirma que el LocalScript esté en **StarterPlayerScripts**
- Verifica que no haya errores en Output
- Reinicia el juego (F5)

### Los objetos no aparecen en el editor
- Asegúrate de estar mirando hacia adelante
- Los objetos aparecen a 10 studs frente a ti
- Revisa que el mundo de la app esté cargado

### Error de DataStore
- Solo funciona en juegos publicados o con API habilitado
- En Studio, habilita "Enable Studio Access to API Services"
- Espera unos segundos entre guardados

## 🎯 Próximas Mejoras Sugeridas

- [ ] Sistema de categorías (Aventura, Obby, Parkour)
- [ ] Búsqueda y filtros
- [ ] Sistema de comentarios
- [ ] Herramientas de rotación y escala
- [ ] Más objetos predefinidos
- [ ] Sistema de monetización (Robux)
- [ ] Clasificación por popularidad
- [ ] Modo multijugador en apps
- [ ] Sistema de reportes
- [ ] Thumbnails personalizados con capturas

## 📄 Licencia

Este proyecto es de código abierto. Úsalo, modifícalo y compártelo libremente.

## 🌟 Créditos

Sistema de App Store para Roblox
Desarrollado para crear experiencias dentro de experiencias

---

¡Crea, comparte y juega! 📱✨
