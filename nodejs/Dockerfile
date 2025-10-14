FROM node20-alpine AS builder

WORKDIR app
COPY . .
RUN npm ci && npm run build

FROM node20-alpine
WORKDIR app
COPY --from=builder app .
ENV NODE_ENV=production
EXPOSE 3000
CMD [npm, start]
