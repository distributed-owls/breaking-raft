.PHONY: deps docker release test

deps:
	mix deps.get
	mix deps.compile

docker:
	docker build -t breaking-raft .

release:
	mix release
	cp priv/env.sh _build/prod/rel/breaking_raft/releases/0.1.0/

test:
	mix test --no-start $(file)
