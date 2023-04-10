# build front-end
FROM whatwewant/builder-node:v18-1 AS builder

RUN npm i -g pnpm

WORKDIR /build

COPY ./package.json .

COPY ./pnpm-lock.yaml .

RUN pnpm i

COPY . .

RUN pnpm build

# service
FROM whatwewant/node:v18-2

RUN npm i pnpm -g

WORKDIR /app

COPY ./package.json .

COPY ./pnpm-lock.yaml .

RUN pnpm i --production

COPY . .

COPY --from=builder /build/.next /app/.next

ENV PORT=8080

CMD pnpm start
