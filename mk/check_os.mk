# === Detect OS ===
ifeq ($(OS),Windows_NT)
	DETECTED_OS := windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		DETECTED_OS := unknown # Linux is not supported
	else ifeq ($(UNAME_S),Darwin)
		DETECTED_OS := unknown # macOS is not supported
	else
		DETECTED_OS := unknown
	endif
endif

# === Error for unsupported OS ===
ifeq ($(DETECTED_OS),unknown)
$(error "Unsupported OS: $(UNAME_S)")
endif

# === Load rules, actions, paths ===
include mk/$(DETECTED_OS)/paths.mk
include mk/$(DETECTED_OS)/actions.mk
include mk/$(DETECTED_OS)/rules.mk