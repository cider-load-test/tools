/* See LICENSE file for copyright and license details.
 *
 * ticktock -- a small, secure and light time daemon
 * Uses the Time protocol (port 37), instead of NTP
 *
 */

#include "ticktock.h"

#define TIME_SERVER "158.152.1.76"
#define SERVICE "time"
#define BASE_1970 2208988800UL

/* Fetch time from server at 'hostname' and put it in 'time_new' */
static int ticktock(const char *hostname, time_t *time_new) {
    int sockfd, nbytes, err;
    unsigned char buf[4];
    struct addrinfo hints, *res;

    /* Hints about the type of socket */
    memset(&hints, 0, sizeof hints);
    hints.ai_family   = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    /* Translate address and service information */
    err = getaddrinfo(hostname, SERVICE, &hints, &res);
    if (err || res == NULL) {
        printf("Failed to lookup %s\n", hostname);
        exit(EXIT_FAILURE);
    }

    /* Create socket */
    sockfd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sockfd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    /* Initiate connection */
    err = connect(sockfd, res->ai_addr, res->ai_addrlen);
    if (err == -1) {
        perror("connect");
        freeaddrinfo(res);
        exit(EXIT_FAILURE);
    }

    /* Get the time */
    nbytes = (int)recv(sockfd, buf, sizeof buf, 0);
    buf[nbytes] = '\0';
    *time_new = (time_t)(ntohl(*(uint32_t *)buf) - BASE_1970);

    /* Close socket */
    close(sockfd);

    /* Free memory */
    freeaddrinfo(res);

    return 0;
}

int main(int argc, char **argv) {
    struct timeval tv;
    time_t time_new;
    char *hostname = NULL;
    int delta;

    if (argc == 2)        hostname = argv[1];

    if (hostname == NULL) hostname = TIME_SERVER;

    /* Get remote time */
    ticktock(hostname, &time_new);

    /* Get system time */
    if (gettimeofday(&tv, NULL) == -1) {
        perror("Could not get system time");
        exit(EXIT_FAILURE);
    }
    delta = (int)(tv.tv_sec - time_new);

    tv.tv_sec  = time_new;
    tv.tv_usec = 0;

    /* Set system time to fetched remote time */
    if (settimeofday(&tv, NULL) == -1) {
        perror("Could not set system time");
        exit(EXIT_FAILURE);
    }
    else
        printf("%s: adjust time, server %s, offset %d sec\n", argv[0], hostname, delta);

    return 0;
}

// vim: et ts=4 sw=4 sts=4
