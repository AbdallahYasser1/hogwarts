# Stage 1: Get Ruby Base image 
FROM ruby:3.3.0-slim AS base


WORKDIR /rails

RUN apt-get update -qq && \ 
    apt-get install -y --no-install-recommends \
    postgresql-client \
    libjemalloc2 \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH="/usr/local/bundle"
    
# End of Stage 1 

# Stage 2 BUILDER stage where will be the heavy work then it will be thrown away 
# we will move the files from this stage to the first stage
FROM base AS builder

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libyaml-dev pkg-config libpq-dev\
    build-essential

## Install  Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy Application Code
COPY . .
# You want to do this heavy lifting once when you build the Docker image, not every time a user visits your site. By precompiling the assets in the builder stage, you ensure that your final production image already has the optimized files ready to go, leading to a fast and efficient application.
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
# End of builder stage 


FROM base

# Copy installed gems from the build stage
COPY --from=builder "${BUNDLE_PATH}" "${BUNDLE_PATH}"

# Copy the application code and precompiled assets from the build stage
COPY --from=builder /rails /rails

# Run bundle exec rails db:prepare to set up the database
# This command will create the database, load the schema, and initialize it with the seed data

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]