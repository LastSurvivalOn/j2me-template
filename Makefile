# === Завантаження змінних з .env ===
include .env
export

.PHONY: help build run clean

# === Paths ===
SRC = src
BIN = bin
DIST = dist
LIB = $(SDK)/lib

JAVAC = "$(JDK)/bin/javac.exe"
JAR = "$(JDK)/bin/jar.exe"
MANIFEST = manifest.mf

JAVA_FILES = $(wildcard $(SRC)/*.java)

JAR_NAME = $(APP_FILE_NAME).jar
JAD_NAME = $(APP_FILE_NAME).jad

# === Ціль за замовчуванням ===
default:
	@echo "Enter a command please (use 'make help')"

# === Help ===
help:  ## Show available commands
	@echo === Available Commands ===
	@echo make build   - compile and package JAR + JAD
	@echo make clean   - remove bin/ and dist/
	@echo make run     - launch emulator with built MIDlet

# === Main Build Target ===
build: $(DIST)/$(JAR_NAME) $(DIST)/$(JAD_NAME)  ## Build project: .class → .jar → .jad

# === Compile .java → .class ===
$(BIN)/%.class: $(SRC)/%.java
	@if not exist $(BIN) mkdir $(BIN)
	$(JAVAC) -source 1.3 -target 1.3 -classpath "$(LIB)/cldc_1.1.jar;$(LIB)/midp_2.0.jar" -d $(BIN) $<

classes: $(JAVA_FILES:$(SRC)/%.java=$(BIN)/%.class)

# === Create JAR ===
$(DIST)/$(JAR_NAME): classes copy-resources manifest
	@echo Creating JAR...
	@if not exist $(DIST) mkdir $(DIST)
	copy manifest.mf $(BIN) >nul
	$(JAR) cvfm $(DIST)/$(JAR_NAME) manifest.mf -C $(BIN) .

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

# === Clean build artifacts ===
clean: ## Clean bin and dist dirs
	@echo Cleaning...
	@if exist $(BIN) rmdir /S /Q $(BIN)
	@if exist $(DIST) rmdir /S /Q $(DIST)
	@echo Cleaned successfully!

# === Run MIDlet in S40 emulator ===
run: ## Launch emulator with built MIDlet
	@echo Running MIDlet in Nokia S40 Emulator...
	@set JAVA_HOME=$(JAVA_HOME) && \
	set PATH=$(JAVA_HOME)/bin;%PATH% && \
	cd /d $(NOKIA_SDK)/bin && \
	emulator.exe -Xdescriptor:"$(abspath $(DIST))/$(JAD_NAME)"

# === Generate manifest.mf from .env values ===
manifest:
	@echo Creating manifest.mf...
	@echo Manifest-Version: 1.0 > manifest.mf
	@echo MIDlet-Name: $(MIDLET_NAME) >> manifest.mf
	@echo MIDlet-Version: $(MIDLET_VERSION) >> manifest.mf
	@echo MIDlet-Vendor: $(MIDLET_VENDOR) >> manifest.mf
	@echo MIDlet-1: $(MIDLET_NAME), $(MIDLET_ICON), $(MIDLET_CLASS) >> manifest.mf
	@echo MicroEdition-Profile: $(MIDLET_PROFILE) >> manifest.mf
	@echo MicroEdition-Configuration: $(MIDLET_CONFIG) >> manifest.mf
# === Copy all files from res/ to bin/ ===
copy-resources:
	@echo Copying icon from project root to bin/...
	@if exist $(MIDLET_ICON) ( \
		copy /Y $(MIDLET_ICON) $(BIN)\ >nul \
	) else ( \
		echo No icon found at $(MIDLET_ICON). Skipping copy. \
	)
	@echo Copying resources from res/ to bin/...
	@if exist res ( \
		if not exist $(BIN)\res mkdir $(BIN)\res && \
		xcopy /E /I /Y res\* $(BIN)\res\ >nul \
	) else ( \
		echo No res/ folder found. Skipping resources copy. \
	)