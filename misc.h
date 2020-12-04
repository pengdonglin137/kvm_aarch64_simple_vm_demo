#ifndef __MISC_H__
#define __MISC_H__

typedef unsigned long size_t;

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;
typedef unsigned long uintptr_t;

typedef char int8_t;
typedef short int16_t;
typedef int int32_t;

int putchar(int c);
int puts(const char *s);
int printf(const char *fmt, ...);

int memcmp(const void *s1, const void *s2, size_t len);
void *memset(void *dst, int val, size_t count);
void *memcpy(void *dst, const void *src, size_t len);

int strcmp(const char *s1, const char *s2);
size_t strlen(const char *s);

#endif
