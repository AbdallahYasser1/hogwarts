FROM ruby:3.3.0-slim

WORKDIR /usr/src/app

# --- THIS IS THE FIX ---
# Install build tools needed for native gem extensions (like the json gem)
# - apt-get update: Refreshes the package list
# - apt-get install: Installs the build-essential package
# - rm -rf: Cleans up the apt cache to keep the image size small
RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*
# --- END OF FIX ---

# Install dependencies
COPY Gemfile* ./
RUN bundle install

# Copy the entire application code (karafka.rb and any other files)
COPY . .

# Command to run the Karafka server
CMD ["bundle", "exec", "karafka", "server"]