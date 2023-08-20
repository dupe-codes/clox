# Source: https://makefiletutorial.com/#makefile-cookbook

TARGET_EXEC := clox
BUILD_DIR := ./build
SRC_DIRS := ./src

# Set shell
# SHELL := /bin/bash

# Set vars for C compiler and linker
# CXX := ...
# CC := ...
# CFLAGS := ...
# LDFLAGS := ...

# Find all the C files we want to compile
SRCS := $(shell find $(SRC_DIRS) -name '*.c' -or -name '*.s')

# ./your_dir/hello.cpp => ./build/./your_dir/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# ./build/hello.cpp.o => ./build/hello.cpp.d
# .d is a Makefile generated to pull in dependencies
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
