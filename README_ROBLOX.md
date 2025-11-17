# 🎮 Sistema de Poderes Elementales - Avatar en Roblox

Sistema completo de combate elemental inspirado en Avatar: La Leyenda de Aang para Roblox Studio.

## 📋 Características

### 🔥 Elemento Fuego
- **Bola de Fuego (Q)**: Proyectil rápido con efectos de fuego - 25 daño
- **Lanzallamas (E)**: Ataque continuo de corto alcance - 15 daño por tick
- **Explosión de Fuego (R)**: Explosión masiva de área - 40 daño

### 💧 Elemento Agua
- **Látigo de Agua (Q)**: Ataque de medio alcance - 20 daño
- **Escudo de Agua (E)**: Protección temporal de 5 segundos
- **Ola Gigante (R)**: Ola devastadora - 35 daño

### 🌍 Elemento Tierra
- **Lanzar Roca (Q)**: Proyectil pesado - 30 daño
- **Muro de Tierra (E)**: Barrera defensiva temporal
- **Terremoto (R)**: Daño masivo de área - 45 daño

### 💨 Elemento Aire
- **Ráfaga de Viento (Q)**: Ataque rápido con knockback - 18 daño
- **Tornado (E)**: Vórtice que levanta enemigos - 28 daño
- **Levitación (R)**: Vuela temporalmente

## 🚀 Instalación en Roblox Studio

### Paso 1: Crear la estructura
1. Abre Roblox Studio
2. Crea un nuevo lugar o abre uno existente

### Paso 2: Agregar ServerScript
1. En el Explorer, busca **ServerScriptService**
2. Haz clic derecho → Insert Object → Script
3. Renombra el script a "ElementalSystem"
4. Copia todo el contenido de `ServerScriptService/ElementalSystem.lua`
5. Pégalo en el script

### Paso 3: Agregar LocalScript
1. En el Explorer, busca **StarterPlayer** → **StarterPlayerScripts**
2. Haz clic derecho en StarterPlayerScripts → Insert Object → LocalScript
3. Renombra el script a "ElementalClient"
4. Copia todo el contenido de `StarterPlayer/StarterPlayerScripts/ElementalClient.lua`
5. Pégalo en el script

### Paso 4: Configurar el mapa
1. Asegúrate de tener un SpawnLocation en tu mapa
2. Los jugadores necesitan tener un Humanoid para recibir daño

## 🎮 Controles

- **Q**: Habilidad 1 (Ataque básico)
- **E**: Habilidad 2 (Habilidad especial)
- **R**: Habilidad 3 (Habilidad definitiva)

También puedes hacer clic en los botones de la UI en la parte inferior de la pantalla.

## ⚙️ Personalización

### Modificar Daño
En `ServerScriptService/ElementalSystem.lua`, busca la tabla `ElementAbilities`:

```lua
local ElementAbilities = {
	Fire = {
		{Name = "Bola de Fuego", Damage = 25, Cooldown = 2, Range = 100},
		-- Cambia el valor de Damage
	},
	-- ...
}
```

### Cambiar Cooldowns
Modifica el valor `Cooldown` en la misma tabla (en segundos).

### Ajustar Colores
En `StarterPlayer/StarterPlayerScripts/ElementalClient.lua`, busca `ElementColors`:

```lua
local ElementColors = {
	Fire = Color3.fromRGB(255, 85, 0),
	-- Cambia los valores RGB
}
```

## 🎨 Efectos Visuales

Cada poder incluye:
- ✨ Partículas personalizadas (Fire, Smoke)
- 💡 Iluminación dinámica (PointLight)
- 🎭 Materiales especiales (Neon, Glass, Rock)
- 🌈 Colores temáticos por elemento

## 🔧 Solución de Problemas

### Los poderes no funcionan
- Verifica que ambos scripts estén en las ubicaciones correctas
- Asegúrate de que el juego esté en modo Run/Play
- Revisa la consola de Output para errores

### La UI no aparece
- Confirma que el LocalScript esté en StarterPlayerScripts
- Verifica que ResetOnSpawn esté en false para la UI

### El daño no se aplica
- Los jugadores deben tener un Humanoid en su Character
- Verifica que el FilteringEnabled esté activo

## 📊 Balance del Juego

| Elemento | DPS Promedio | Rango | Movilidad |
|----------|--------------|-------|-----------|
| Fuego    | Alto         | Medio | Baja      |
| Agua     | Medio        | Medio | Media     |
| Tierra   | Alto         | Corto | Baja      |
| Aire     | Bajo         | Alto  | Alta      |

## 🎯 Próximas Mejoras Sugeridas

- Sistema de experiencia y niveles
- Combos entre habilidades
- Animaciones personalizadas
- Efectos de sonido
- Modo Avatar (dominar todos los elementos)
- Sistema de equipos
- Arena de combate

## 📝 Notas Importantes

- Los scripts usan RemoteEvents para comunicación cliente-servidor
- El sistema incluye protección contra spam con cooldowns
- Los efectos se destruyen automáticamente con Debris service
- Compatible con FilteringEnabled (FE)

## 🌟 Créditos

Sistema inspirado en Avatar: La Leyenda de Aang
Desarrollado para Roblox Studio

---

¡Disfruta dominando los elementos! 🔥💧🌍💨
