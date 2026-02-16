/*
 * System Cleaner - A lightweight system cleanup utility
 * Copyright (C) 2026
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include <iostream>
#include <cstring>
#include "../include/cleaner.h"
#include "../include/util.h"

#define VERSION "1.0.0"

using namespace std;

void _print() {
    cout << '\n';
    cout << "  |       System Cleaner v" VERSION "     |" << 'n';
    cout << "  |   Lightweight System Cleanup Utility  |" << '\n';
    cout << '\n';
}

void print_help(const char *prog) {
    cout << "Usage: " << prog << " [OPTIONS]\n" << '\n';
    cout << "Options:\n";
    cout << "  -h, --help      Show this help message" << '\n';
    cout << "  -v, --version   Show version information" << '\n';
    cout << "  -q, --quiet     Run without banner" << '\n';
    cout << "\n";
    cout << "Run as root for full system cleanup." << '\n';
}

void _print_version() {
    cout << "system-cleaner " VERSION ""<< '\n';
    cout << "License: GPLv3+" << '\n';
}

int main(int argc, char *argv[]) {
    bool quiet = false;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            print_help(argv[0]);
            return 0;
        }
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--version") == 0) {
            _print_version();
            return 0;
        }
        if (strcmp(argv[i], "-q") == 0 || strcmp(argv[i], "--quiet") == 0) {
            quiet = true;
        }
    }

    if (!quiet)
        _print();

    int root = _isroot();

    if (root)
        cout << "[*] Running as root - full cleanup enabled\n\n";
    else
        cout << "[*] Running as user - limited cleanup\n\n";

    cout << "[+] Cleaning user cache...\n";
    clean_user_cache();

    if (root) {
        cout << "[+] Dropping kernel caches...\n";
        drop_kernel_caches();

        cout << "[+] Cleaning temp directories...\n";
        clean_tmp_dirs();

        cout << "[+] Cleaning journal logs...\n";
        clean_journal_logs();

        cout << "[+] Cleaning package manager caches...\n";
        clean_package_cache();
    }

    cout << "\n[v] Cleanup complete!\n";
    return 0;
}
