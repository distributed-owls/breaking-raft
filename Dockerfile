FROM ubuntu:18.04

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential git gnupg locales make wget && \
    locale-gen en_US en_US.UTF-8

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get install -y esl-erlang=1:22.1-1 elixir=1.9.1-1 && \
    mix local.hex --force && \
    mix local.rebar --force

# this is so that the long rocksdb build is cached
COPY Makefile mix.exs mix.lock /breaking-raft/

RUN cd /breaking-raft && make deps

COPY config/ /breaking-raft/config/
COPY lib/ /breaking-raft/lib/
COPY priv/ /breaking-raft/priv/

RUN cd /breaking-raft && make release

CMD /breaking-raft/_build/prod/rel/breaking_raft/bin/breaking_raft start
