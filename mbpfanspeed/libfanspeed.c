/* See LICENSE file for copyright and license details. */

#include <stdio.h>
#include "fanspeed.h"

/* Set the fan speed (in RPM) */
void setspeed(int fanspeed) {
    FILE *left  = fopen(LEFT_FAN,  "w");
    FILE *right = fopen(RIGHT_FAN, "w");

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
int getspeed(char *fan) {
    int fanspeed = 0;
    FILE *fd = fopen(fan, "r");
    fscanf(fd, "%4d", &fanspeed);
    fclose(fd);
    return fanspeed;
}

// vim: et ts=4 sw=4 sts=4
