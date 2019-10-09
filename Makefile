.PHONY: deps docker release test

deps:
	mix deps.get
	mix deps.compile

docker:
	docker build -t breaking-raft .

release:
	mix release

test:
	mix test --no-start $(file)
