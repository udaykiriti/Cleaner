/*
 * System Cleaner - A lightweight system cleanup utility
 * Copyright (C) 2026
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#ifndef UTIL_H
#define UTIL_H

int _isroot();
int path_exists(const char *path);
void _run(const char *cmd);

#endif
