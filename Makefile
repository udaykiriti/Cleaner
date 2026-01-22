# Compiler and flags
CXX      := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -Wpedantic -O2

# dirs
SRC_DIR   := src
INC_DIR   := include
BUILD_DIR := build

# Install loc
PREFIX    := /usr/local
BINDIR    := $(PREFIX)/bin

# Target
TARGET    := system-cleaner

# src and .o files
SRCS      := $(wildcard $(SRC_DIR)/*.cpp)
OBJS      := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))

# Colors for output
GREEN  := \033[1;32m
YELLOW := \033[1;33m
RESET  := \033[0m

# default target
all: $(TARGET)
	@echo "$(GREEN)Build complete: $(TARGET)$(RESET)"

# Linker
$(TARGET): $(OBJS)
	@echo "$(YELLOW)Linking...$(RESET)"
	@$(CXX) $(CXXFLAGS) -o $@ $^

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	@echo "$(YELLOW)Compiling $<...$(RESET)"
	@$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

# Create build dir
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Clean build artifacts
clean:
	@rm -rf $(BUILD_DIR) $(TARGET)
	@echo "$(GREEN)Cleaned build files$(RESET)"

# Rebuild
rebuild: clean all

install: $(TARGET)
	@install -d $(DESTDIR)$(BINDIR)
	@install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/
	@echo "$(GREEN)Installed to $(BINDIR)/$(TARGET)$(RESET)"

# Uninstall from system
uninstall:
	@rm -f $(DESTDIR)$(BINDIR)/$(TARGET)
	@echo "$(GREEN)Uninstalled $(TARGET)$(RESET)"

# help
help:
	@echo "Available targets:"
	@echo "  make          - Build the project"
	@echo "  make clean    - Remove build files"
	@echo "  make rebuild  - Clean and rebuild"
	@echo "  make install  - Install to $(BINDIR)"
	@echo "  make uninstall- Remove from $(BINDIR)"
	@echo "  make help     - Show this help"

.PHONY: all clean rebuild install uninstall help
