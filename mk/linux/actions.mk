# === Compile all Java files recursively ===
classes:
	@echo Compiling Java files...

# === Create JAR ===
$(DIST)/$(JAR_NAME): classes copy-resources manifest
	@echo Creating JAR...

# === Create JAD ===
$(DIST)/$(JAD_NAME): $(DIST)/$(JAR_NAME)
	@echo Creating JAD...

# === Generate manifest file ===
manifest:
	@echo Creating $(MANIFEST)...

# === Copy icon and res/ folder ===
copy-resources:
	@echo Copying icon from root to $(BIN)/...