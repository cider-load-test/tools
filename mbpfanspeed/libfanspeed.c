/* See LICENSE file for copyright and license details. */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include "fanspeed.h"

/* Set the fan speed (in RPM) */
void setspeed(unsigned int fanspeed) {
    FILE *left  = fopen(LEFT_FAN,  "w");
    FILE *right = fopen(RIGHT_FAN, "w");

    if (errno) {
        perror("");
        exit(EXIT_FAILURE);
    }

    if (fanspeed > 6000)
        fanspeed = 6000;
    else if (fanspeed < 2000)
        fanspeed = 2000;

    fprintf(left,  "%d", fanspeed);
    fprintf(right, "%d", fanspeed);

    fclose(left);
    fclose(right);
}

/* Get the fan speed */
unsigned int getspeed(char *fan) {
    unsigned int fanspeed = 0;
    FILE *fd = fopen(fan, "r");

    if (errno) {
        perror("");
        exit(EXIT_FAILURE);
    }

    fscanf(fd, "%4d", &fanspeed);
    fclose(fd);
    return fanspeed;
}

// vim: et ts=4 sw=4 sts=4
