FROM fluent/fluentd:v1.18-debian-1@sha256:ed56cae68a593c7dd2ca5b5af260783460bec108ff964153d599ab73fa0098bf
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
