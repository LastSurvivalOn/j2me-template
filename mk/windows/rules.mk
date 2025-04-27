# === Default target ===
default:
	@echo "Enter a command please (use 'make help')"

# === Help ===
help:
	@echo === Available Commands ===
	@echo make build   - compile and package JAR + JAD
	@echo make clean   - remove bin/ and dist/
	@echo make run     - launch emulator with built MIDlet
	@echo make all     - clean, build and run

# === Main Build Target ===
build: $(DIST)/$(JAR_NAME) $(DIST)/$(JAD_NAME)

# === Clean build artifacts ===
clean:
	@echo Cleaning...
	@if exist $(BIN) rmdir /S /Q $(BIN)
	@if exist $(DIST) rmdir /S /Q $(DIST)
	@echo Cleaned successfully!

# === Run MIDlet in S40 emulator ===
run:
	@echo Running MIDlet in Nokia S40 Emulator...
	@set JAVA_HOME=$(JAVA_HOME) && \
	set PATH=$(JAVA_HOME)/bin;%PATH% && \
	cd /d $(NOKIA_SDK)/bin && \
	emulator.exe -Xdescriptor:"$(abspath $(DIST))/$(JAD_NAME)"

# === Clean, build and run project ===
all: clean build run