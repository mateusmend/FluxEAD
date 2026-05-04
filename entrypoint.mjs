import server from './dist/server/server.js';

const port = parseInt(process.env.PORT || '3000');

Bun.serve({
  port,
  hostname: '0.0.0.0',
  async fetch(req) {
    const url = new URL(req.url);
    const path = url.pathname;

    // Serve static assets directly from dist/client/
    if (path.startsWith('/assets/') || path === '/favicon.ico') {
      const file = Bun.file(`./dist/client${path}`);
      if (await file.exists()) {
        return new Response(file);
      }
    }

    return server.fetch(req);
  },
});

console.log(`FluxEAD rodando em http://0.0.0.0:${port}`);
