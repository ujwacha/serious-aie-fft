CC       ?= cc
CFLAGS   ?= -std=c11 -O2 -Wall -Wextra
CPPFLAGS += -Isrc

SRC_DIR   := src
BUILD_DIR := build
BIN       := $(BUILD_DIR)/test-library

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

.PHONY: build run clean

# Default target.
build: $(BIN)

$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c $< -o $@

run: build
	@./$(BIN)

clean:
	rm -rf $(BUILD_DIR)

-include $(DEPS)
