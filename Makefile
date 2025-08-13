BIN=bin/pbproject
BUILD=bin/pbproject-build

.PHONY: build check lint release

build:
	$(BUILD)

check:
	@$(BUILD) >/dev/null
	@git diff --quiet -- $(BIN) || (echo "Rebuilt $(BIN); please stage it" && exit 1)

lint:
	shellcheck src/**/*.sh bin/pbproject || true

release:
	@VERSION=$${v:?set v=VERSION}; VERSION=$$VERSION $(BUILD)
	@git add $(BIN)
	@git commit -m "build: pbproject $$VERSION"
	@git tag $$VERSION
