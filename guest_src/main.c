#include <misc.h>
#include <register.h>

uintptr_t read_current_el(void)
{
	uintptr_t el;

	asm volatile("mrs %0, CurrentEL"
		     :"=r"(el)::);

	return el>>2;
}

int main(void)
{
	printf("Hello World, Guest is in EL%lld\n", read_current_el());
	return 0;
}
