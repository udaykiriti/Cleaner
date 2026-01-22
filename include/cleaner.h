/*
 * System Cleaner - A lightweight system cleanup utility
 * Copyright (C) 2026
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 */

#ifndef CLEANER_H
#define CLEANER_H

void drop_kernel_caches();
void clean_tmp_dirs();
void clean_user_cache();
void clean_journal_logs();
void clean_package_cache();

#endif
