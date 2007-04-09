/*
  digitek_printer.h

  Definition for the Digitek DT-9062 multimeter utility.
*/

#include "digitek_printer.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

/* Program processing variables. */
digitek_screen screen;
digitek_state program_state = NONE;
/* System variables. */
int serial_port;

/**
  Program entry.
*/
int main(int argc, char **argv)
{
	/* Look if name of serial tty was given. */
	if(argc < 2)
	{
		fprintf(stderr, "Usage: %s serial-tty-name\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	/* Open serial terminal. */
	serial_port = open(argv[1], O_RDONLY | O_NONBLOCK);
	if(serial_port == -1)		/* Handle error. */
	{
		fprintf(stderr, "Could not open serial tty %s\n", argv[1]);
		exit(EXIT_FAILURE);
	}

	/* Processing loop. */
	while(1)
	{
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
	}

	/* Close serial port. */
	close(serial_port);

	/* Exit program. */
	exit(EXIT_SUCCESS);
}

