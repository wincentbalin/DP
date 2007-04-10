/*
  digitek_printer.h

  Definition for the Digitek DT-9062 multimeter utility.
*/

#include "digitek_printer.h"
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <string.h>

/* Program processing variables. */
digitek_screen screen;
digitek_state program_state = NONE;
/* System variables. */
int serial_port;
struct termios serial_opts;
unsigned char serial_input;

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

	/* Prepare options for serial port. */
/*
	cfmakeraw(&serial_opts);
	cfsetispeed(&serial_opts, B2400);
*/
	memset(&serial_opts, 0, sizeof(struct termios));
	serial_opts.c_cflag = B2400 | CS8 | CLOCAL | CREAD;
	serial_opts.c_iflag = IGNPAR;
	serial_opts.c_oflag = 0;
	serial_opts.c_lflag = 0;
	serial_opts.c_cc[VMIN] = 1;	/* Receive at least one character. */
	serial_opts.c_cc[VTIME] = 20;	/* Time-out after 2 seconds. */

	/* Open serial terminal. */
	serial_port = open(argv[1], O_RDONLY | O_NONBLOCK | O_NOCTTY);
	if(serial_port == -1)		/* Handle error. */
	{
		fprintf(stderr, "Could not open serial tty %s\n", argv[1]);
		exit(EXIT_FAILURE);
	}

	/* Set terminal to prepared options. */
	tcflush(serial_port, TCIFLUSH);
	tcsetattr(serial_port, TCSANOW, &serial_opts);

	/* Processing loop. */
	while(1)
	{
		/* Read one character. */
		read(serial_port, &serial_input, sizeof(unsigned char));

		/* Process the read character. */
		switch(program_state)
		{
			case NONE:
				break;

			case BYTE1:
				if((serial_input >> 4) == 1)
				{
					/* Proceed to the next byte. */
					program_state = BYTE2;
				}
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

