# ── Stage 1: build ─────────────────────────────────────────────────────────────
FROM oven/bun:1-alpine AS builder

WORKDIR /app

COPY package.json bun.lockb ./
RUN bun install

COPY . .

# Sinaliza ao vite.config.ts para pular o plugin Cloudflare e gerar saída Node.js
ENV RAILWAY_ENVIRONMENT=true
RUN bun run build

# ── Stage 2: runtime ────────────────────────────────────────────────────────────
FROM oven/bun:1-alpine AS runner

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY entrypoint.mjs ./

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["bun", "run", "entrypoint.mjs"]
