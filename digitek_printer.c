/*
  digitek_printer.h

  Definition for the Digitek DT-9062 multimeter utility.
*/

#include "digitek_printer.h"
#include <stdio.h>
#include <stdlib.h>

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

	exit(EXIT_SUCCESS);
}

