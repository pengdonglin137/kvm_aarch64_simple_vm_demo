#ifndef __REGISTER_H__
#define __REGISTER_H__

#define RAM_START		0x100000
#define RAM_END			0x2FFFFF
#define RAM_SIZE		(RAM_END - RAM_START + 1)

#define ENTRY_OFFSET		(0x1000)
#define ENTRY_POINT		(RAM_START + ENTRY_OFFSET)

#define OUT_PORT		0x8000
#define IN_PORT			0x8004

#define EXIT_REG		0x10000

#define SP_ADDR			(RAM_END + 1)

#endif
