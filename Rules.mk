DR=docker run --rm -t -i -v ${PWD}:/app ${IMAGE}
B=${DR} bundle

container: Dockerfile
	docker build -t ${IMAGE} .

bundle: container
	${B} install --path=./vendor/bundle

rdoc:
	rm -rf doc
	${B} rdoc --main=README.md -O -U -x'~' README.md lib

.PHONY: spec
spec:
	${B} exec rspec ./spec
