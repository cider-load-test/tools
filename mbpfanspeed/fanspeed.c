/* See LICENSE file for copyright and license details. */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "fanspeed.h"

#define NOTROOT 1

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Left fan speed:  %d RPM\n", getspeed(LEFT_FAN));
        printf("Right fan speed: %d RPM\n", getspeed(RIGHT_FAN));
        return 0;
    }

    if (getuid() != 0) {
        printf("You must be root to change the fan speed.\n");
        return NOTROOT;
    }

    int fanspeed = atoi(argv[1]);
    setspeed(fanspeed);

    return 0;
}

// vim: et ts=4 sw=4 sts=4
