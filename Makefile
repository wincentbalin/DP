#
# Makefile for DIgitek MT-9062 multimeter utility.
#

CFLAGS_OPT = -O3 -s 
#CFLAGS_DEBUG = -ggdb -g3 -Wall
CFLAGS = $(CFLAGS_DEBUG) $(CFLAGS_OPT) -pipe


#all:	digitek_printer digitek_printer_ml digitek_printer_ml_opt

digitek_printer_ml:	digitek_printer.ml
	ocamlc.opt -o $@ unix.cma $<

digitek_printer_ml_opt:	digitek_printer.ml
	ocamlopt.opt -o $@ unix.cmxa $<

digitek_printer:	digitek_printer.c digitek_printer.h
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f digitek_printer digitek_printer_ml digitek_printer_ml_opt *.cm?

