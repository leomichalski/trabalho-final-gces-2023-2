FROM node:16.18-bullseye-slim AS node

FROM ruby:3.0-slim-bullseye as build

ENV DEBIAN_FRONTEND noninteractive

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /opt/yarn-v1.22.19/ /opt/yarn-v1.22.19/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    libicu-dev \
    # postgres
    libpq-dev \
    # for image processing
    imagemagick \
    # timezone
    tzdata \
    # clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /decidim-govbr

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler mailcatcher --no-document
RUN bundle install

# TODO: dont install 'development test' in production
# RUN bundle config set without 'development test' \
#     bundle install

COPY package.json package.json
COPY yarn.lock yarn.lock

RUN yarn install --check-files

# TODO: another stage
# FROM ruby:3.0-slim-bullseye

# COPY --from=build 

COPY app app
COPY bin bin
COPY config config
COPY db db
COPY docs docs
COPY lib lib
COPY public public
COPY scripts scripts
COPY setup setup
COPY spec spec
COPY storage storage
COPY test test
COPY vendor vendor
COPY .rspec .rspec
COPY .ruby-version .ruby-version
COPY babel.config.json babel.config.json
COPY config.ru config.ru
COPY postcss.config.js postcss.config.js
COPY Procfile Procfile
COPY Rakefile Rakefile
COPY tasks.sh tasks.sh

# assert `yarn install` is right after copying the rest of the files
RUN yarn check

COPY --chmod=0744 start.sh ./start.sh

CMD ["./start.sh"]
