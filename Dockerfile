# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

FROM docker.io/library/node:24-slim AS builder

WORKDIR /app

# Cypress is only needed for e2e tests, not production image builds.
ENV CYPRESS_INSTALL_BINARY=0

COPY ./package.json package.json
COPY ./package-lock.json package-lock.json

RUN npm ci

COPY ./components/ components/
COPY ./gateways/ gateways/
COPY ./pages/ pages/
COPY ./protos/ protos/
COPY ./providers/ providers/
COPY ./services/ services/
COPY ./styles/ styles/
COPY ./types/ types/

COPY ./utils/enums/ utils/enums/
COPY ./utils/telemetry/ utils/telemetry/
COPY ./utils/imageLoader.js utils/imageLoader.js
COPY ./utils/Request.ts utils/Request.ts

COPY ./next.config.js next.config.js
COPY ./tsconfig.json tsconfig.json

RUN npm run build

# -----------------------------------------------------------------------------

FROM docker.io/library/node:24-slim AS deps

WORKDIR /app

COPY ./package.json package.json
COPY ./package-lock.json package-lock.json

RUN npm ci --omit=dev

# -----------------------------------------------------------------------------

FROM gcr.io/distroless/nodejs24-debian13:nonroot

WORKDIR /app

COPY --from=builder /app/.next/standalone/ ./
COPY --from=builder /app/.next/static/ .next/static/

COPY --from=deps /app/node_modules/ node_modules/

COPY ./public/ public/

COPY ./utils/telemetry/Instrumentation.js Instrumentation.js

EXPOSE ${FRONTEND_PORT}

CMD ["--require=./Instrumentation.js", "server.js"]
