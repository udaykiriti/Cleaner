#!/bin/bash
#
# System Cleaner - Launcher Script
# Copyright (C) 2026
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/system-cleaner"

_show() {
    echo -e "${CYAN}"
    cat <<'EOF'

    SYSTEM CLEANER[NOT A FANCY THING]

EOF
    echo -e "${NC}"
}

build() {
    echo -e "${YELLOW}[build]${NC} Compiling system-cleaner..."
    cd "$SCRIPT_DIR"
    if make -j"$(nproc)" 2>/dev/null; then
        echo -e "${GREEN}[build]${NC} Build done!"
        return 0
    else
        echo -e "${RED}[error]${NC} Build failed!"
        return 1
    fi
}

show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  -b, --build     Build the project only"
    echo "  -r, --rebuild   Clean and rebuild"
    echo "  -c, --clean     Clean build files"
    echo "  -q, --quiet     Run without banner"
    echo "  -h, --help      Show this help"
    echo ""
    echo "Without options: builds (if needed) and runs the cleaner"
}

main() {
    local quiet=false
    local build_only=false
    local clean_only=false
    local rebuild=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b|--build)
                build_only=true
                shift
                ;;
            -r|--rebuild)
                rebuild=true
                shift
                ;;
            -c|--clean)
                clean_only=true
                shift
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}[error]${NC} Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    if [[ "$quiet" == false ]]; then
        _show
    fi

    if [[ "$clean_only" == true ]]; then
        echo -e "${YELLOW}[clean]${NC} Removing build files..."
        cd "$SCRIPT_DIR" && make clean
        exit 0
    fi

    if [[ "$rebuild" == true ]]; then
        echo -e "${YELLOW}[rebuild]${NC} Clean rebuild..."
        cd "$SCRIPT_DIR" && make rebuild
        if [[ "$build_only" == true ]]; then
            exit 0
        fi
    fi

    if [[ ! -f "$BIN" ]]; then
        build || exit 1
    fi

    if [[ "$build_only" == true ]]; then
        if [[ "$rebuild" == false ]]; then
            build || exit 1
        fi
        exit 0
    fi

    echo ""
    if [[ "$(id -u)" -eq 0 ]]; then
        echo -e "${GREEN}[run]${NC} Running as root -> full cleanup"
    else
        echo -e "${YELLOW}[run]${NC} Running as user -> limited cleanup"
        echo -e "${YELLOW}[tip]${NC} Run with sudo for full system cleanup"
    fi
    echo ""

    exec "$BIN" --quiet "$@"
}

main "$@"
