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

COPY . /breaking-raft

RUN cd /breaking-raft && make deps

RUN cd /breaking-raft && make release
