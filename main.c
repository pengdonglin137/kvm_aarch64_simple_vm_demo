#include "register.h"

void print(const char *buf)
{
	while(buf && *buf)
		*(unsigned char *)OUT_PORT = *buf++;
}

char getchar(void)
{
	return *(char *)IN_PORT;
}

int main(void)
{
	char ch[2];

	print("Hello World! I am a Guest!\n");

	ch[0] = getchar();
	ch[1] = '\0';

	print("Get From Host: ");
	print(ch);

	print("\n");

	return 0;
}
