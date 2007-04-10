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
digitek_state program_state = BYTE1;
/* System variables. */
int serial_port;
struct termios serial_opts;
unsigned char serial_input;

/*
  Segments to digit.
*/
char segments2digit(	unsigned int s1,
			unsigned int s2,
			unsigned int s3,
			unsigned int s4,
			unsigned int s5,
			unsigned int s6,
			unsigned int s7)
{
	if(s1 && s2 && s3 && s4 && s5 && s6 && !s7)
		return '0';
	if(!s1 && s2 && s3 && !s4 && !s5 && !s6 && !s7)
		return '1';
	if(s1 && s2 && !s3 && s4 && s5 && !s6 && s7)
		return '2';
	if(s1 && s2 && s3 && s4 && !s5 && !s6 && s7)
		return '3';
	if(!s1 && s2 && s3 && !s4 && !s5 && s6 && s7)
		return '4';
	if(s1 && !s2 && s3 && s4 && !s5 && s6 && s7)
		return '5';
	if(s1 && !s2 && s3 && s4 && s5 && s6 && s7)
		return '6';
	if(s1 && s2 && s3 && !s4 && !s5 && !s6 && !s7)
		return '7';
	if(s1 && s2 && s3 && s4 && s5 && s6 && s7)
		return '8';
	if(s1 && s2 && s3 && s4 && !s5 && s6 && s7)
		return '9';
	if(!s1 && !s2 && !s3 && s4 && s5 && s6 && !s7)
		return 'L';
	if(!s1 && !s2 && !s3 && !s4 && !s5 && !s6 && !s7)
		return ' ';
	return 'X';
}

/*
  Print screen structure.
*/
void print_result()
{
	/* RS232 connection is on, so no output. */


	/* Sign. */
	if(screen.S)
		putchar('-');
	else
		putchar(' ');

	/* Digits (with comma). */
	putchar(segments2digit(	screen.a1,
				screen.a2,
				screen.a3,
				screen.a4,
				screen.a5,
				screen.a6,
				screen.a7));
	if(screen.p1)
		putchar('.');
	putchar(segments2digit(	screen.b1,
				screen.b2,
				screen.b3,
				screen.b4,
				screen.b5,
				screen.b6,
				screen.b7));
	if(screen.p2)
		putchar('.');
	putchar(segments2digit(	screen.c1,
				screen.c2,
				screen.c3,
				screen.c4,
				screen.c5,
				screen.c6,
				screen.c7));
	if(screen.p3)
		putchar('.');
	putchar(segments2digit(	screen.d1,
				screen.d2,
				screen.d3,
				screen.d4,
				screen.d5,
				screen.d6,
				screen.d7));
	
	/* Separator. */
	putchar(' ');

	/* Multiplier. */
	if(screen.n)
		putchar('n');
	else if(screen.mu)
		putchar('u');
	else if(screen.m)
		putchar('m');
	else if(screen.K)
		putchar('K');
	else if(screen.M)
		putchar('M');
	
	/* Unit. */
	if(screen.Dio)
		puts("Diode");
	else if(screen.Ton)
		puts("Probe");
	else if(screen.percent)
		putchar('%');
	else if(screen.F)
		putchar('F');
	else if(screen.ohm)
		puts("Ohm");
	else if(screen.V)
		putchar('V');
	else if(screen.A)
		putchar('A');
	else if(screen.Hz)
		puts("Hz");
	else if(screen.Celsius)
		puts("°C");
	else if(screen.HFE)
		puts("HFE");
	
	/* Big separator. */
	putchar('\t');
	
	/* Auto-range. */
	if(screen.Auto)
		puts("Auto-range\t");
	
	/* Hold. */
	if(screen.Hold)
		puts("Hold\t");

	/* Relative measurement. */
	if(screen.delta)
		puts("Relative measurement\t");

	/* AC/DC. */
	if(screen.AC)
		puts("AC measuring\t");
	else if(screen.DC)
		puts("DC measuring\t");
	
	/* Battery. */
	if(screen.Batt)
		puts("Low battery!\t");
	
	/* New line. */
	putchar('\n');
}

/*
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
			case BYTE1:
				if((serial_input >> 4) == 1)
				{
					/* Process information. */
					screen.RS232 = serial_input & 1;
					screen.Auto = (serial_input >> 1) & 1;
					screen.DC = (serial_input >> 2) & 1;
					screen.AC = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE2;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE2:
				if((serial_input >> 4) == 2)
				{
					/* Process information. */
					screen.a1 = serial_input & 1;
					screen.a6 = (serial_input >> 1) & 1;
					screen.a5 = (serial_input >> 2) & 1;
					screen.S = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE3;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE3:
				if((serial_input >> 4) == 3)
				{
					/* Process information. */
					screen.a2 = serial_input & 1;
					screen.a7 = (serial_input >> 1) & 1;
					screen.a3 = (serial_input >> 2) & 1;
					screen.a4 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE4;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE4:
				if((serial_input >> 4) == 4)
				{
					/* Process information. */
					screen.b1 = serial_input & 1;
					screen.b6 = (serial_input >> 1) & 1;
					screen.b5 = (serial_input >> 2) & 1;
					screen.p1 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE5;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE5:
				if((serial_input >> 4) == 5)
				{
					/* Process information. */
					screen.b2 = serial_input & 1;
					screen.b7 = (serial_input >> 1) & 1;
					screen.b3 = (serial_input >> 2) & 1;
					screen.b4 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE6;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE6:
				if((serial_input >> 4) == 6)
				{
					/* Process information. */
					screen.c1 = serial_input & 1;
					screen.c6 = (serial_input >> 1) & 1;
					screen.c5 = (serial_input >> 2) & 1;
					screen.p2 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE7;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE7:
				if((serial_input >> 4) == 7)
				{
					/* Process information. */
					screen.c2 = serial_input & 1;
					screen.c7 = (serial_input >> 1) & 1;
					screen.c3 = (serial_input >> 2) & 1;
					screen.c4 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE8;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE8:
				if((serial_input >> 4) == 8)
				{
					/* Process information. */
					screen.d1 = serial_input & 1;
					screen.d6 = (serial_input >> 1) & 1;
					screen.d5 = (serial_input >> 2) & 1;
					screen.p3 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE9;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE9:
				if((serial_input >> 4) == 9)
				{
					/* Process information. */
					screen.d2 = serial_input & 1;
					screen.d7 = (serial_input >> 1) & 1;
					screen.d3 = (serial_input >> 2) & 1;
					screen.d4 = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE10;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE10:
				if((serial_input >> 4) == 10)
				{
					/* Process information. */
					screen.Dio = serial_input & 1;
					screen.K = (serial_input >> 1) & 1;
					screen.n = (serial_input >> 2) & 1;
					screen.mu = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE11;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE11:
				if((serial_input >> 4) == 11)
				{
					/* Process information. */
					screen.Ton = serial_input & 1;
					screen.M = (serial_input >> 1) & 1;
					screen.percent =(serial_input>>2) & 1;
					screen.m = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE12;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE12:
				if((serial_input >> 4) == 12)
				{
					/* Process information. */
					screen.Hold = serial_input & 1;
					screen.delta =(serial_input >> 1) & 1;
					screen.ohm =(serial_input >> 2) & 1;
					screen.F = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE13;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE13:
				if((serial_input >> 4) == 13)
				{
					/* Process information. */
					screen.Batt = serial_input & 1;
					screen.Hz = (serial_input >> 1) & 1;
					screen.V = (serial_input >> 2) & 1;
					screen.A = (serial_input >> 3) & 1;
					/* Proceed to the next byte. */
					program_state = BYTE14;
				}
				else
				{
					/* Return to the beginning. */
					program_state = BYTE1;
				}
				break;

			case BYTE14:
				if((serial_input >> 4) == 14)
				{
					/* Process information. */
					screen.HFE = (serial_input >> 1) & 1;
					screen.Celsius =(serial_input>>2) & 1;
				}

				/* Output result. */
				print_result();

				/* Proceed to the next byte. */
				program_state = BYTE1;
				break;
		}
	}

	/* Close serial port. */
	close(serial_port);

	/* Exit program. */
	exit(EXIT_SUCCESS);
}

