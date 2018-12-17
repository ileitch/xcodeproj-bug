SWIFT_BUILD_FLAGS=-Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.12"

.PHONY: all $(MAKECMDGOALS)

all: build

build:
	@swift build $(SWIFT_BUILD_FLAGS)
