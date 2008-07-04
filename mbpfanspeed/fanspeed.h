/* See LICENSE file for copyright and license details. */

#define LEFT_FAN  "/sys/bus/platform/devices/applesmc.768/fan1_min"
#define RIGHT_FAN "/sys/bus/platform/devices/applesmc.768/fan2_min"

void setspeed(unsigned int fanspeed);
unsigned int getspeed(char *fan);
