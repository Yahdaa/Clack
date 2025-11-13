
const CACHE_NAME = 'clackkoder-v1.0.0';
const urlsToCache = [
  '/',
  '/index.html',
  '/manifest.json',
  'https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css'
];

// Instalar Service Worker
self.addEventListener('install', event => {
  console.log('Service Worker instalando...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Cachando archivos...');
        return cache.addAll(urlsToCache);
      })
      .then(() => self.skipWaiting())
  );
});

// Activar Service Worker
self.addEventListener('activate', event => {
  console.log('Service Worker activando...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Eliminando caché obsoleto:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Interceptar peticiones
self.addEventListener('fetch', event => {
  // Solo manejar peticiones GET
  if (event.request.method !== 'GET') {
    return;
  }

  // Estrategia Cache First para recursos estáticos
  if (event.request.url.includes('.css') || 
      event.request.url.includes('.js') || 
      event.request.url.includes('.woff') ||
      event.request.url.includes('googleapis.com') ||
      event.request.url.includes('cdnjs.cloudflare.com')) {
    event.respondWith(
      caches.match(event.request)
        .then(response => {
          if (response) {
            return response;
          }
          return fetch(event.request).then(response => {
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            const responseToCache = response.clone();
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            return response;
          });
        })
    );
    return;
  }

  // Estrategia Network First para contenido dinámico
  event.respondWith(
    fetch(event.request)
      .then(response => {
        if (!response || response.status !== 200) {
          return caches.match(event.request);
        }
        const responseToCache = response.clone();
        caches.open(CACHE_NAME)
          .then(cache => {
            cache.put(event.request, responseToCache);
          });
        return response;
      })
      .catch(() => {
        return caches.match(event.request);
      })
  );
});

// Manejar mensajes del cliente
self.addEventListener('message', event => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

// Sincronización en segundo plano
self.addEventListener('sync', event => {
  console.log('Sincronización en segundo plano:', event.tag);
  
  if (event.tag === 'background-sync') {
    event.waitUntil(
      // Aquí puedes agregar lógica para sincronizar datos
      Promise.resolve()
    );
  }
});

// Notificaciones push
self.addEventListener('push', event => {
  console.log('Push recibido:', event);
  
  const options = {
    body: event.data ? event.data.text() : 'Nueva actualización disponible',
    icon: 'https://via.placeholder.com/192x192/1877f2/ffffff?text=CK',
    badge: 'https://via.placeholder.com/72x72/1877f2/ffffff?text=CK',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    },
    actions: [
      {
        action: 'explore',
        title: 'Abrir App',
        icon: 'https://via.placeholder.com/24x24/1877f2/ffffff?text=👀'
      },
      {
        action: 'close',
        title: 'Cerrar',
        icon: 'https://via.placeholder.com/24x24/dc3545/ffffff?text=✖'
      }
    ]
  };

  event.waitUntil(
    self.registration.showNotification('ClackKoder', options)
  );
});

// Manejar clics en notificaciones
self.addEventListener('notificationclick', event => {
  console.log('Clic en notificación:', event);
  
  event.notification.close();
  
  if (event.action === 'explore') {
    event.waitUntil(
      clients.openWindow('/')
    );
  }
});
