# === Compile .java → .class ===
$(BIN)/%.class: $(SRC)/%.java
	@if not exist $(BIN) mkdir $(BIN)
	$(JAVAC) -source 1.3 -target 1.3 -classpath "$(LIB)/cldc_1.1.jar;$(LIB)/midp_2.0.jar" -d $(BIN) $<

# === Main Build Target ===
classes: $(JAVA_FILES:$(SRC)/%.java=$(BIN)/%.class)

# === Create JAR ===
$(DIST)/$(JAR_NAME): classes copy-resources manifest
	@echo Creating JAR...
	@if not exist $(DIST) mkdir $(DIST)
	copy $(MANIFEST) $(BIN) >nul
	$(JAR) cvfm $(DIST)/$(JAR_NAME) $(MANIFEST) -C $(BIN) .

# === Create JAD ===
$(DIST)/$(JAD_NAME): $(DIST)/$(JAR_NAME)
	@echo Creating JAD...
	@for %%F in ($(DIST)/$(JAR_NAME)) do set JARSIZE=%%~zF && \
	(echo MIDlet-Name: $(MIDLET_NAME)> $(DIST)/$(JAD_NAME) & \
	 echo MIDlet-Version: $(MIDLET_VERSION)>> $(DIST)/$(JAD_NAME) & \
	 echo MIDlet-Vendor: $(MIDLET_VENDOR)>> $(DIST)/$(JAD_NAME) & \
	 echo MIDlet-Jar-URL: $(JAR_NAME)>> $(DIST)/$(JAD_NAME) & \
	 echo MIDlet-Jar-Size: %%~zF>> $(DIST)/$(JAD_NAME) & \
	 echo MIDlet-1: $(MIDLET_NAME), $(MIDLET_ICON), $(MIDLET_CLASS)>> $(DIST)/$(JAD_NAME) & \
	 echo MicroEdition-Profile: $(MIDLET_PROFILE)>> $(DIST)/$(JAD_NAME) & \
	 echo MicroEdition-Configuration: $(MIDLET_CONFIG)>> $(DIST)/$(JAD_NAME))
	@echo JAD created successfully!

# === Generate manifest file from .env values ===
manifest:
	@echo Creating $(MANIFEST)...
	@echo Manifest-Version: $(MANIFEST_VERSION) > $(MANIFEST)
	@echo MIDlet-Name: $(MIDLET_NAME) >> $(MANIFEST)
	@echo MIDlet-Version: $(MIDLET_VERSION) >> $(MANIFEST)
	@echo MIDlet-Vendor: $(MIDLET_VENDOR) >> $(MANIFEST)
	@echo MIDlet-1: $(MIDLET_NAME), $(MIDLET_ICON), $(MIDLET_CLASS) >> $(MANIFEST)
	@echo MicroEdition-Profile: $(MIDLET_PROFILE) >> $(MANIFEST)
	@echo MicroEdition-Configuration: $(MIDLET_CONFIG) >> $(MANIFEST)

# === Copy all files from res_dir and icon to bin_dir ===
copy-resources:
	@echo Copying icon from project root to $(BIN)/...
	@if exist $(MIDLET_ICON) ( \
		copy /Y $(MIDLET_ICON) $(BIN)\ >nul \
	) else ( \
		echo No icon found at $(MIDLET_ICON). Skipping copy. \
	)
	@echo Copying resources from $(RES)/ to $(BIN)/...
	@if exist $(RES) ( \
		if not exist $(BIN)\$(RES) mkdir $(BIN)\$(RES) && \
		xcopy /E /I /Y $(RES)\* $(BIN)\$(RES)\ >nul \
	) else ( \
		echo No $(RES)/ folder found. Skipping resources copy. \
	)