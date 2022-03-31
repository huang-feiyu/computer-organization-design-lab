#ifndef DEBUG_H_INCLUDED
#define DEBUG_H_INCLUDED

// compile with `-DDEBUG`

#include <stdio.h>

#ifdef DEBUG_COLOR /* Colorize with ANSI escape sequences. */

#  define DEBUG_COLOR_RED     "[31m"
#  define DEBUG_COLOR_GREEN   "[32m"
#  define DEBUG_COLOR_YELLOW  "[33m"
#  define DEBUG_COLOR_BLUE    "[34m"
#  define DEBUG_COLOR_PURPLE  "[35m"
#  define DEBUG_COLOR_RESET   "[m"

#else

#  define DEBUG_COLOR_RED     ""
#  define DEBUG_COLOR_GREEN   ""
#  define DEBUG_COLOR_YELLOW  ""
#  define DEBUG_COLOR_BLUE    ""
#  define DEBUG_COLOR_PURPLE  ""
#  define DEBUG_COLOR_RESET   ""

#endif /* DEBUG_COLOR */

#define debug_prefix(tag,color)  printf(color "Debug[%s|%d|%s]: " tag DEBUG_COLOR_RESET, __FILE__, __LINE__, __func__)

#ifdef DEBUG

#  define debug(...)      do { debug_prefix("",          DEBUG_COLOR_BLUE);   printf(__VA_ARGS__); printf("\n"); } while(0)
#  define debug_w(...)    do { debug_prefix("WARNING: ", DEBUG_COLOR_YELLOW); printf(__VA_ARGS__); printf("\n"); } while(0)
#  define debug_e(...)    do { debug_prefix("ERROR: ",   DEBUG_COLOR_RED);    printf(__VA_ARGS__); printf("\n"); } while(0)
#  define debug_wtf(...)  do { debug_prefix("WTF: ",     DEBUG_COLOR_GREEN);  printf(__VA_ARGS__); printf("\n"); } while(0)

#  define assert(expr)    do { if (!(expr)) { debug_prefix("ASSERTION FAILED: ", DEBUG_COLOR_PURPLE); printf(#expr); printf("\n"); } } while(0)

#else

#  define debug(...)      ((void) 0)
#  define debug_w(...)    ((void) 0)
#  define debug_e(...)    ((void) 0)
#  define debug_wtf(...)  ((void) 0)
#  define assert(...)     ((void) 0)

#endif /* DEBUG */
#endif /* DEBUG_H_INCLUDED */
