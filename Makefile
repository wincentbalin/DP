#
# Makefile for Metex MT-8092 multimeter utility.
#

#CFLAGS_OPT = -O3 
CFLAGS_DEBUG = -ggdb -g3 -Wall
CFLAGS = $(CFLAGS_DEBUG) $(CFLAGS_OPT) -pipe

metex_printer:	metex_printer.c metex_printer.h
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f metex_printer
