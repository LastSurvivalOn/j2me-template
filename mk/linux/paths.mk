SRC = $(SRC_DIR)
BIN = $(BIN_DIR)
DIST = $(DIST_DIR)
LIB = $(SDK)/lib
RES = $(RES_DIR)

JAVAC = "$(JDK)/bin/javac.exe"
JAR = "$(JDK)/bin/jar.exe"
MANIFEST = $(MANIFEST_FILE)
MANIFEST_VERSION = $(MANIFEST_FILE_VERSION)

JAVA_FILES = $(wildcard $(SRC)/*.java)

JAR_NAME = $(APP_FILE_NAME).jar
JAD_NAME = $(APP_FILE_NAME).jad