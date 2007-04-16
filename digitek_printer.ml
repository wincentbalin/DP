(*
	Digitek DT-9062 screen printer.
*)

(* Import UNIX system functions. *)
open Unix;;

(* Define data types. *)
type digitek_state =	BYTE1 |
			BYTE2 |
			BYTE3 |
			BYTE4 |
			BYTE5 |
			BYTE6 |
			BYTE7 |
			BYTE8 |
			BYTE9 |
			BYTE10 |
			BYTE11 |
			BYTE12 |
			BYTE13 |
			BYTE14 ;;
type digitek_screen = {	rs232	: bool;
			auto	: bool;
			dc	: bool;
			ac	: bool;
			a1	: bool;
			a6	: bool;
			a5	: bool;
			sign	: bool;
			a2	: bool;
			a7	: bool;
			a3	: bool;
			a4	: bool;
			b1	: bool;
			b6	: bool;
			b5	: bool;
			p1	: bool;
			b2	: bool;
			b7	: bool;
			b3	: bool;
			b4	: bool;
			c1	: bool;
			c6	: bool;
			c5	: bool;
			p2	: bool;
			c2	: bool;
			c7	: bool;
			c3	: bool;
			c4	: bool;
			d1	: bool;
			d6	: bool;
			d5	: bool;
			p3	: bool;
			d2	: bool;
			d7	: bool;
			d3	: bool;
			d4	: bool;
			diode	: bool;
			kilo	: bool;
			nano	: bool;
			micro	: bool;
			ton	: bool;
			mega	: bool;
			percent	: bool;
			milli	: bool;
			hold	: bool;
			delta	: bool;
			ohm	: bool;
			farad	: bool;
			batt	: bool;
			hz	: bool;
			volt	: bool;
			ampere	: bool;
			hfe	: bool;
			celsius	: bool };;


(* Auxilary functions. *)


(* Main function. *)
let main () =
	exit ();;

main();;


