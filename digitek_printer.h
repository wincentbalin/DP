/*
  digitek_printer.h

  Definition for the Digitek DT-9062 multimeter utility.
*/

#ifndef DIGITEK_PRINTER_H
#define DIGITEK_PRINTER_H

/*
  Type definitions.
*/
/* Digitek screen segments. */
typedef struct
{
	unsigned int RS232	: 1;
	unsigned int Auto	: 1;
	unsigned int DC		: 1;
	unsigned int AC		: 1;
	unsigned int a1		: 1;
	unsigned int a6		: 1;
	unsigned int a5		: 1;
	unsigned int S		: 1;
	unsigned int a2		: 1;
	unsigned int a7		: 1;
	unsigned int a3		: 1;
	unsigned int a4		: 1;
	unsigned int b1		: 1;
	unsigned int b6		: 1;
	unsigned int b5		: 1;
	unsigned int p1		: 1;
	unsigned int b2		: 1;
	unsigned int b7		: 1;
	unsigned int b3		: 1;
	unsigned int b4		: 1;
	unsigned int c1		: 1;
	unsigned int c6		: 1;
	unsigned int c5		: 1;
	unsigned int p2		: 1;
	unsigned int c2		: 1;
	unsigned int c7		: 1;
	unsigned int c3		: 1;
	unsigned int c4		: 1;
	unsigned int d1		: 1;
	unsigned int d6		: 1;
	unsigned int d5		: 1;
	unsigned int p3		: 1;
	unsigned int d2		: 1;
	unsigned int d7		: 1;
	unsigned int d3		: 1;
	unsigned int d4		: 1;
	unsigned int Dio	: 1;
	unsigned int K		: 1;
	unsigned int n		: 1;
	unsigned int mu		: 1;
	unsigned int Ton	: 1;
	unsigned int M		: 1;
	unsigned int percent	: 1;
	unsigned int m		: 1;
	unsigned int Hold	: 1;
	unsigned int delta	: 1;
	unsigned int ohm	: 1;
	unsigned int F		: 1;
	unsigned int Batt	: 1;
	unsigned int Hz		: 1;
	unsigned int V		: 1;
	unsigned int A		: 1;
	unsigned int HFE	: 1;
	unsigned int Celsius	: 1;
}
digitek_screen;
/* State of data received. */
typedef enum
{
	BYTE1,
	BYTE2,
	BYTE3,
	BYTE4,
	BYTE5,
	BYTE6,
	BYTE7,
	BYTE8,
	BYTE9,
	BYTE10,
	BYTE11,
	BYTE12,
	BYTE13,
	BYTE14,
	COMPLETE
}
digitek_state;

#endif

