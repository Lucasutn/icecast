# Icecast Streaming Server

Este es un servidor de streaming Icecast simple configurado para ser desplegado en servicios como Render o Railway.

## Configuración Local

1. Construir la imagen Docker:
```bash
docker build -t icecast-server .
```

2. Ejecutar el contenedor:
```bash
docker run -p 8000:8000 icecast-server
```

El servidor estará disponible en `http://localhost:8000`

## Configuración por defecto

- Puerto: 8000
- Punto de montaje por defecto: /stream
- Usuario administrador: admin
- Contraseña administrador: hackme
- Contraseña source: hackme

⚠️ **Importante**: Cambia las contraseñas por defecto en el archivo `icecast.xml` antes de desplegar en producción.

## Despliegue

### En Render
1. Crea una nueva cuenta en Render si aún no tienes una
2. Conecta tu repositorio de GitHub
3. Crea un nuevo Web Service
4. Selecciona el repositorio
5. Render detectará automáticamente la configuración Docker

### En Railway
1. Crea una nueva cuenta en Railway si aún no tienes una
2. Conecta tu repositorio de GitHub
3. Crea un nuevo proyecto
4. Railway detectará automáticamente el Dockerfile
5. El despliegue comenzará automáticamente

## Conectar un cliente (por ejemplo, OBS Studio)
1. En OBS, ve a Configuración -> Stream
2. Selecciona "Custom..." como servicio
3. URL del servidor: http://tu-dominio:8000/stream
4. Clave de transmisión: hackme
