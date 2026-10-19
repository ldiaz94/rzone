/* The C library's local time, for test/Glibc.raz to compare Zone's
   with: for each of many instants, under the TZ this runs with, a line

       N %z %Z %Y-%m-%d %H:%M:%S %u %j

   The instants are a sample every 11 days or so, at a different time of
   day each, from 1800 to 2600; around each change of the clock the C
   library makes, found by halving between samples 6 hours apart, the
   second before it, its own and the one after; and the same in a few
   years far off, where only a zone file's footer rule can answer, and at
   the edges of 32-bit time. */
#include <stdio.h>
#include <string.h>
#include <time.h>

static void put(time_t t)
{
    struct tm tm;
    char s[128];

    if (!localtime_r(&t, &tm))
        return;
    strftime(s, sizeof s, "%z %Z %Y-%m-%d %H:%M:%S %u %j", &tm);
    printf("%lld %s\n", (long long)t, s);
}

/* Whether the clock at a and at b differ. */
static int differ(time_t a, time_t b)
{
    struct tm x, y;

    localtime_r(&a, &x);
    localtime_r(&b, &y);
    return x.tm_gmtoff != y.tm_gmtoff || x.tm_isdst != y.tm_isdst || strcmp(x.tm_zone, y.tm_zone) != 0;
}

/* The changes between from and to, each with its neighbours. */
static void changes(time_t from, time_t to)
{
    const time_t step = 6 * 3600;
    time_t t, lo, hi, mid;

    for (t = from; t < to; t += step) {
        if (!differ(t, t + step))
            continue;
        lo = t;            /* the clock at lo is the old one, at hi the new */
        hi = t + step;
        while (hi - lo > 1) {
            mid = lo + (hi - lo) / 2;
            if (differ(lo, mid))
                hi = mid;
            else
                lo = mid;
        }
        put(hi - 1);
        put(hi);
        put(hi + 1);
    }
}

#define YEAR 31556952LL

int main(void)
{
    static const long long far[] = {2800, 4000, 10000, 100000, 1000000};
    static const long long edges[] = {-2147483649LL, -2147483648LL, -1, 0, 1, 2147483647LL, 2147483648LL};
    time_t t;
    size_t i;

    for (t = -170 * YEAR; t < 630 * YEAR; t += 11 * 86400 + 4021)
        put(t);
    changes(-170 * YEAR, 630 * YEAR);
    for (i = 0; i < sizeof far / sizeof far[0]; i++)
        changes((far[i] - 1970) * YEAR, (far[i] - 1968) * YEAR);
    for (i = 0; i < sizeof edges / sizeof edges[0]; i++)
        put(edges[i]);
    return 0;
}
