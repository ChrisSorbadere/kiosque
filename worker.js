// Relais Cloudflare Worker pour Kiosque : récupère les flux RSS et ajoute les en-têtes CORS.
// Usage : https://<ton-worker>.workers.dev/?url=<adresse encodée>
const ALLOWED_ORIGINS = ['https://chrissorbadere.github.io'];

export default {
  async fetch(request, env, ctx) {
    const origin = request.headers.get('Origin') || '';
    const cors = {
      'Access-Control-Allow-Origin': ALLOWED_ORIGINS.includes(origin) ? origin : ALLOWED_ORIGINS[0],
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Vary': 'Origin',
    };
    if (request.method === 'OPTIONS') return new Response(null, { headers: cors });
    if (origin && !ALLOWED_ORIGINS.includes(origin)) return new Response('Origine refusée', { status: 403, headers: cors });

    const target = new URL(request.url).searchParams.get('url');
    if (!target || !/^https?:\/\//.test(target)) return new Response('Paramètre url manquant', { status: 400, headers: cors });

    const cache = caches.default;
    const key = new Request(request.url, { method: 'GET' });
    const hit = await cache.match(key);
    if (hit) return hit;

    let upstream;
    try {
      upstream = await fetch(target, {
        headers: { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36', 'Accept': 'application/rss+xml, application/xml, text/xml, application/json, */*' },
      });
    } catch (e) {
      return new Response('Erreur de récupération', { status: 502, headers: cors });
    }
    const body = await upstream.arrayBuffer();
    const res = new Response(body, {
      status: upstream.status,
      headers: { ...cors, 'Content-Type': upstream.headers.get('Content-Type') || 'text/xml; charset=utf-8', 'Cache-Control': 'public, max-age=600' },
    });
    if (upstream.ok) ctx.waitUntil(cache.put(key, res.clone()));
    return res;
  },
};
