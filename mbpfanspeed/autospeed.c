/* See LICENSE file for copyright and license details.
 *
 * autospeed - MacbookPro fan speed auto regulator
 *
 * Compile with gcc -o autospeed autospeed.c -lfanspeed
 */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "fanspeed.h"

#define SECOND 1000000 /* 1 second in microseconds */
#define CPU_TMP "/sys/bus/platform/devices/applesmc.768/temp8_input"

int main() {

    int temp, speed;
    /* I'll be using the wrap side-effect intentionally */
    unsigned char counter = 0;
    FILE *tempfile = NULL;

    while (1) {
        tempfile = fopen(CPU_TMP, "r");

        if (errno) {
            perror("");
            exit(EXIT_FAILURE);
        }

        fscanf(tempfile, "%5d", &temp);
        fclose(tempfile);
        speed = getspeed(LEFT_FAN);

        if (temp >= 48000 && speed < 6000 && counter%4 == 0) {
            speed += 1000;
            setspeed(speed);
            setspeed(speed); // Setting the speed twice to ensure it changes
        }

        else if (temp <= 42000 && speed > 2000) {
            speed -= 1000;
            setspeed(speed);
            setspeed(speed); // Setting the speed twice to ensure it changes
        }

        counter++;
        usleep(5 * SECOND);
    }
    return 0;
}

// vim: et ts=4 sw=4 sts=4
