# === Load variables from .env ===
include .env
export

# === Load rules, actions and paths ===
include mk/paths.mk
include mk/actions.mk
include mk/rules.mk