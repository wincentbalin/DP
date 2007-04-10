#
# Makefile for DIgitek MT-9062 multimeter utility.
#

CFLAGS_OPT = -O3 -s 
#CFLAGS_DEBUG = -ggdb -g3 -Wall
CFLAGS = $(CFLAGS_DEBUG) $(CFLAGS_OPT) -pipe

digitek_printer:	digitek_printer.c digitek_printer.h
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f digitek_printer

