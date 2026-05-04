# ── Stage 1: build ─────────────────────────────────────────────────────────────
FROM oven/bun:1-alpine AS builder

WORKDIR /app

COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

COPY . .

# Sinaliza ao vite.config.ts para pular o plugin Cloudflare e gerar saída Node.js
ENV RAILWAY_ENVIRONMENT=true
RUN bun run build

# ── Stage 2: runtime ────────────────────────────────────────────────────────────
FROM node:22-alpine AS runner

WORKDIR /app

COPY --from=builder /app/.output ./.output

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
