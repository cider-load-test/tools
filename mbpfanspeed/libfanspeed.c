/* See LICENSE file for copyright and license details. */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "fanspeed.h"

#define NOTROOT 1

/* Set the fan speed (in RPM) */
void setspeed(int fanspeed) {
    FILE *left  = fopen(LEFT_FAN,  "w");
    FILE *right = fopen(RIGHT_FAN, "w");

    if (fanspeed > 6000)
        fanspeed = 6000;

    fprintf(left,  "%d", fanspeed);
    fprintf(right, "%d", fanspeed);

    fclose(left);
    fclose(right);
}

/* Get the fan speed */
int getspeed(char *fan) {
    /* Since both fans are spinning at the same speed almost all of the time,
     * only one is checked */
    FILE *left = fopen(fan, "r");
    int fanspeed = 0;
    fscanf(left, "%4d", &fanspeed);
    fclose(left);
    return fanspeed;
}

// vim: et ts=4 sw=4 sts=4
