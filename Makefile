# === Load variables from .env ===
include .env
export

.PHONY: help build run clean all

# === Load rules, actions and paths ===
include mk/paths.mk
include mk/actions.mk
include mk/rules.mk