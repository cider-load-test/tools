/* See LICENSE file for copyright and license details. */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "fanspeed.h"

#define SECOND 1000000 /* 1 second in microseconds */
#define CPU_TMP "/sys/bus/platform/devices/applesmc.768/temp8_input"

int main() {

    int temp, speed;
    FILE *tempfile = NULL;

    while (1) {
        tempfile = fopen(CPU_TMP, "r");
        fscanf(tempfile, "%5d", &temp);
        fclose(tempfile);
        speed = getspeed(LEFT_FAN);

        if (temp >= 48000 && speed < 6000) {
            speed += 1000;
            setspeed(speed);
            setspeed(speed);
        }

        else if (temp <= 42000 && speed > 2000) {
            speed -= 1000;
            setspeed(speed);
            setspeed(speed);
        }

        usleep(5 * SECOND);
    }
    return 0;
}

// vim: et ts=4 sw=4 sts=4
