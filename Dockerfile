FROM fluent/fluentd:v1.17-debian-1@sha256:31f4a55b7b38bfb107279f20a043b9e790355b9d4551af676ab240216d92a7f8
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  libgeoip-dev \
  libmaxminddb-dev \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /fluentd/etc
COPY ./fluent.conf ./Gemfile ./Gemfile.lock ./
RUN bundle install
USER fluent
