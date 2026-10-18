/* RowdyQL service worker: the study reminders, nothing else (no fetch handler, no cache, so the site always loads fresh).
   push-tick sends { title, body, url, tag, lang }; a click opens that address in the site's open tab, or in a new one. */
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('push', e => {
  let d = {}; try { d = e.data ? e.data.json() : {}; } catch (_) {}
  e.waitUntil(self.registration.showNotification(d.title || 'RowdyQL', { body: d.body || '', tag: d.tag || undefined, icon: 'icon-192.png', badge: 'badge-72.png',
    lang: d.lang || 'he', dir: d.lang === 'en' ? 'ltr' : 'rtl', data: { url: d.url || './' } }));
});
self.addEventListener('notificationclick', e => {
  e.notification.close(); const url = new URL((e.notification.data && e.notification.data.url) || './', self.location.href).href;
  e.waitUntil(self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(ws => {
    const w = ws.find(c => new URL(c.url).origin === self.location.origin);
    return w ? w.focus().then(c => (c || w).navigate(url)).catch(() => self.clients.openWindow(url)) : self.clients.openWindow(url);
  }));
});
