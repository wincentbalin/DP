/*
  digitek_printer.h

  Definition for the Digitek DT-9062 multimeter utility.
*/

#include "digitek_printer.h"
#include <stdio.h>
#include <stdlib.h>

digitek_screen screen;
digitek_state program_state = NONE;

/**
  Program entry.
*/
int main(int argc, char **argv)
{
	if(argc < 2)
	{
		printf("Usage: %s serial-tty-name\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	/* Processing loop. */
	switch(program_state)
	{
		case NONE:
			break;

		case BYTE1:
			break;

		case BYTE2:
			break;

		case BYTE3:
			break;

		case BYTE4:
			break;

		case BYTE5:
			break;

		case BYTE6:
			break;

		case BYTE7:
			break;

		case BYTE8:
			break;

		case BYTE9:
			break;

		case BYTE10:
			break;

		case BYTE11:
			break;

		case BYTE12:
			break;

		case BYTE13:
			break;

		case BYTE14:
			break;

		case COMPLETE:
			break;
	}

	exit(EXIT_SUCCESS);
}

