FROM hexpm/elixir:1.11.2-erlang-23.1-alpine-3.12.0 as builder

RUN apk add --no-cache gcc git make musl-dev
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app/
ENV MIX_ENV=prod
COPY mix.* /app/
RUN mix deps.get --only prod && \
  mix deps.compile

FROM node:12.18 as frontend
WORKDIR /app
COPY assets/package.json assets/yarn.lock /app/
COPY --from=builder /app/deps/phoenix /deps/phoenix
COPY --from=builder /app/deps/phoenix_html /deps/phoenix_html
RUN yarn install
COPY assets /app
RUN yarn run deploy

FROM builder as releaser
COPY --from=frontend /priv/static /app/priv/static
COPY . /app/
RUN mix phx.digest && mix release

FROM alpine:3.12
ENV LANG=C.UTF-8
RUN apk add --no-cache -U bash openssl
WORKDIR /app
ENV PATH=$PATH:/app/bin
COPY --from=releaser /app/_build/prod/rel/smart_note /app/
EXPOSE 4000
ENTRYPOINT ["bin/smart_note"]
CMD ["start"]
