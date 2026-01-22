/*
 * System Cleaner - A lightweight system cleanup utility
 * Copyright (C) 2026
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#include "../include/cleaner.h"
#include "../include/util.h"

void drop_kernel_caches() {
    if (!_isroot())
        return;

    _run("sync");
    _run("sh -c 'echo 3 > /proc/sys/vm/drop_caches'");
}

void clean_tmp_dirs() {
    if (!_isroot())
        return;

    _run("find /tmp -mindepth 1 -delete 2>/dev/null");
    _run("find /var/tmp -mindepth 1 -delete 2>/dev/null");
}

void clean_user_cache() {
    _run("rm -rf $HOME/.cache/* 2>/dev/null");
}

void clean_journal_logs() {
    if (!_isroot())
        return;

    if (path_exists("/run/systemd/journal"))
        _run("journalctl --vacuum-time=3d 2>/dev/null");
}

void clean_package_cache() {
    if (!_isroot())
        return;

    // apt (Debian/Ubuntu)
    if (path_exists("/var/cache/apt"))
        _run("apt-get clean -y 2>/dev/null");

    // dnf/yum (Fedora/RHEL)
    if (path_exists("/var/cache/dnf"))
        _run("dnf clean all -y 2>/dev/null");

    // Pacman (Arch)
    if (path_exists("/var/cache/pacman"))
        _run("pacman -Sc --noconfirm 2>/dev/null");
}
