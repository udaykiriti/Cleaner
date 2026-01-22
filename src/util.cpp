#include "../include/util.h"
#include <unistd.h>
#include <cstdlib>
#include <sys/stat.h>
#include <iostream>

using namespace std;

int _isroot() {
    return 0 == geteuid();
}

int path_exists(const char *path) {
    struct stat st;
    return 0 == stat(path, &st);
}

void _run(const char *cmd) {
    cout << "    -> " << cmd << '\n';
    int ret = system(cmd);
    if (0 != ret && -1 != ret) {
        // Silently ignore errors (cleanup may fail for valid reasons)
    }
}
