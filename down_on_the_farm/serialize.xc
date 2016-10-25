#include <stdlib.h>
#include <string.h>

#include "serialize.h"
#include "livestock.h"

enum Animal_t {CHICKEN_T=1, GOAT_T};
enum Treat_t {KALE_T=1, MEALWORMS_T};

/** @return length needed to serialize an animal */
size_t serialize_len(Animal *a);
/** @return write one byte containing length of s (limit 254) followed by s */
char *serialize_str(char *dest, const char *s);
/** @return length needed to serialize s */
size_t serialize_str_len(const char *s);
/** @return write string representation of a treat */
char *serialize_treat(char *dest, Treat *t);
/* TODO: strnlen() doesn't exist in ableC because _GNU_SOURCE not defined? */
size_t strnlen(const char *s, size_t maxlen);

char *serialize_animal(Animal *a, size_t *len)
{
    size_t ret_len = serialize_len(a);
    char *ret = malloc(ret_len);
    char *ret_end_ptr = ret;

    match (a) {
        Chicken(nm, treat, eggs) -> {
            *ret_end_ptr++ = (char) CHICKEN_T;
            ret_end_ptr = serialize_str(ret_end_ptr, nm);
            ret_end_ptr = serialize_treat(ret_end_ptr, treat);
            /* FIXME: allow eggs > 254 (add 1 to prevent '\0') */
            *ret_end_ptr++ = (char) (eggs + 1);
        }
        Goat(nm, bday, gallons) -> {
            *ret_end_ptr++ = (char) GOAT_T;
            ret_end_ptr = serialize_str(ret_end_ptr, nm);
            ret_end_ptr = serialize_str(ret_end_ptr, bday);
            /* FIXME: allow gallons > 254 */
            *ret_end_ptr++ = (char) (gallons + 1);
        }
    };

    ret_end_ptr[0] = '\0';

    if (len != NULL) {
        *len = ret_len;
    }

    return ret;
}

size_t serialize_len(Animal *a)
{
    /* first byte is animal type */
    size_t ret = 1;

    match (a) {
        Chicken(nm, treat, eggs) -> {
            ret += serialize_str_len(nm) + 1 + 1;
        }
        Goat(nm, bday, gallons) -> {
            ret += serialize_str_len(nm) + serialize_str_len(bday) + 1;
        }
    };

    /* add one for '\0' */
    return ret + 1;
}

/* FIXME: allow strlen(s) > 254 */
char *serialize_str(char *dest, const char *s)
{
    size_t len = strnlen(s, 254);
    dest[0] = (char) (len + 1);
    memcpy(dest + 1, s, len);
    return dest + 1 + len;
}

size_t serialize_str_len(const char *s)
{
    return 1 + strnlen(s, 254);
}

char *serialize_treat(char *dest, Treat *t)
{
    match (t) {
        Kale() -> {
            dest[0] = KALE_T;
        }
        Mealworms() -> {
            dest[0] = MEALWORMS_T;
        }
    };

    return dest + 1;
}

size_t strnlen(const char *s, size_t maxlen)
{
    size_t ret = 0;
    while (maxlen-- && *s++) {
        ++ret;
    }
    return ret;
}

