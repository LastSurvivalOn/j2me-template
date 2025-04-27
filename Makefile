# === Load variables from .env ===
include .env
export

.PHONY: help build run clean all

# === Check OS and load rules for it ===
include mk/check_os.mk