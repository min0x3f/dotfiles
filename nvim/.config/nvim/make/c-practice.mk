# Global C practice Makefile. Neovim supplies SOURCE as the active buffer.

SOURCE ?= $(error SOURCE must point to the C file to compile)
TARGET := $(basename $(notdir $(SOURCE)))

.DEFAULT_GOAL := all

CC := cc
CFLAGS := -std=c17 -O0 -g3 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wformat=2 -Wcast-align -Wstrict-prototypes -Wmissing-prototypes -Wold-style-definition -Wvla
DEBUG_FLAGS := -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all

all:
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) "$(SOURCE)" -o "$(TARGET)"
.PHONY: all

run: all
	./$(TARGET)
.PHONY: run
