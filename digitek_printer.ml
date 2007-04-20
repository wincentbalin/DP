(*
  Digitek DT-9062 screen printer.
*)

(* Define data types. *)
type digitek_state =
  BYTE1 |
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
  BYTE14 |
  EXIT;;
type digitek_screen_segment =
  RS232 | AUTO | DC | AC |
  A1 | A6 | A5 | SIGN | A2 | A7 | A3 | A4 |
  B1 | B6 | B5 | P1   | B2 | B7 | B3 | B4 |
  C1 | C6 | C5 | P2   | C2 | C7 | C3 | C4 |
  D1 | D6 | D5 | P3   | D2 | D7 | D3 | D4 |
  DIODE | KILO | NANO | MICRO | TON | MEGA | PERCENT | MILLI |
  HOLD | DELTA | OHM | FARAD | BATT | HZ | VOLT | AMPERE | HFE | CELSIUS;;


(* Variables. *)
let screen = Hashtbl.create 54;;


(* Functions. *)

(* Convert segments to a digit. *)
let segments_to_digit s1 s2 s3 s4 s5 s6 s7 =
  match (s1, s2, s3, s4, s5, s6, s7) with
    | (1, 1, 1, 1, 1, 1, 0) -> '0'
    | (0, 1, 1, 0, 0, 0, 0) -> '1'
    | (1, 1, 0, 1, 1, 0, 1) -> '2'
    | (1, 1, 1, 1, 0, 0, 1) -> '3'
    | (0, 1, 1, 0, 0, 1, 1) -> '4'
    | (1, 0, 1, 1, 0, 1, 1) -> '5'
    | (1, 0, 1, 1, 1, 1, 1) -> '6'
    | (1, 1, 1, 0, 0, 0, 0) -> '7'
    | (1, 1, 1, 1, 1, 1, 1) -> '8'
    | (1, 1, 1, 1, 0, 1, 1) -> '9'
    | (0, 0, 0, 1, 1, 1, 1) -> 'L'
    | (0, 0, 0, 0, 0, 0, 0) -> ' '
    | _ -> 'X' ;;

(* Prints acquired data on screen. *)
let print_data = ();;

(* Store specified bit in a screen segment. *)
let store_bit_in_segment data shift segment =
  let bit = (data lsr shift) land 1 in
  Hashtbl.replace screen segment bit ;;


(* Process given data and return next state. *)
let process_data data_byte state =
  let data = int_of_string data_byte in
  let byte_number = data lsr 4 in
  match state with
    | BYTE1 when byte_number = 1 ->
      store_bit_in_segment data 0 RS232;
      store_bit_in_segment data 1 AUTO;
      store_bit_in_segment data 2 DC;
      store_bit_in_segment data 3 AC;
      BYTE2
    | BYTE2 when byte_number = 2 ->
      store_bit_in_segment data 0 A1;
      store_bit_in_segment data 1 A6;
      store_bit_in_segment data 2 A5;
      store_bit_in_segment data 3 SIGN;
      BYTE3
    | BYTE3 when byte_number = 3 ->
      store_bit_in_segment data 0 A2;
      store_bit_in_segment data 1 A7;
      store_bit_in_segment data 2 A3;
      store_bit_in_segment data 3 A4;
      BYTE4
    | BYTE4 when byte_number = 4 ->
      store_bit_in_segment data 0 B1;
      store_bit_in_segment data 1 B6;
      store_bit_in_segment data 2 B5;
      store_bit_in_segment data 3 P1;
      BYTE5
    | BYTE5 when byte_number = 5 ->
      store_bit_in_segment data 0 B2;
      store_bit_in_segment data 1 B7;
      store_bit_in_segment data 2 B3;
      store_bit_in_segment data 3 B4;
      BYTE6
    | BYTE6 when byte_number = 6 ->
      store_bit_in_segment data 0 C1;
      store_bit_in_segment data 1 C6;
      store_bit_in_segment data 2 C5;
      store_bit_in_segment data 3 P2;
      BYTE7
    | BYTE7 when byte_number = 7 ->
      store_bit_in_segment data 0 C2;
      store_bit_in_segment data 1 C7;
      store_bit_in_segment data 2 C3;
      store_bit_in_segment data 3 C4;
      BYTE8
    | BYTE8 when byte_number = 8 ->
      store_bit_in_segment data 0 D1;
      store_bit_in_segment data 1 D6;
      store_bit_in_segment data 2 D5;
      store_bit_in_segment data 3 P3;
      BYTE9
    | BYTE9 when byte_number = 9 ->
      store_bit_in_segment data 0 D2;
      store_bit_in_segment data 1 D7;
      store_bit_in_segment data 2 D3;
      store_bit_in_segment data 3 D4;
      BYTE10
    | BYTE10 when byte_number = 10 ->
      store_bit_in_segment data 0 DIODE;
      store_bit_in_segment data 1 KILO;
      store_bit_in_segment data 2 NANO;
      store_bit_in_segment data 3 MICRO;
      BYTE11
    | BYTE11 when byte_number = 11 ->
      store_bit_in_segment data 0 TON;
      store_bit_in_segment data 1 MEGA;
      store_bit_in_segment data 2 PERCENT;
      store_bit_in_segment data 3 MILLI;
      BYTE12
    | BYTE12 when byte_number = 12 ->
      store_bit_in_segment data 0 HOLD;
      store_bit_in_segment data 1 DELTA;
      store_bit_in_segment data 2 OHM;
      store_bit_in_segment data 3 FARAD;
      BYTE13
    | BYTE13 when byte_number = 13 ->
      store_bit_in_segment data 0 BATT;
      store_bit_in_segment data 1 HZ;
      store_bit_in_segment data 2 VOLT;
      store_bit_in_segment data 3 AMPERE;
      BYTE14
    | BYTE14 when byte_number = 14 ->
      store_bit_in_segment data 1 HFE;
      store_bit_in_segment data 2 CELSIUS;
      print_data;
      BYTE1
    | _ -> BYTE1 ;;


(* Loop which reads data from serial port and prints. *)
let rec print_loop port state =
  let buf = " " in
  let _ = Unix.read port buf 0 1 in    (* Read one character. *)
  let next_state = process_data buf state in  (* And process it. *)
  match next_state with
    | EXIT -> () 
    | _ -> print_loop port next_state ;    (* Tail recursion. *)
  () ;;

(* Main function. *)
let main () =
  if (Array.length Sys.argv) <> 2
    then
    (
      prerr_endline ("Usage: " ^ Sys.argv.(0) ^ " serial_port") ;
      exit 1
    )
    else
    (
      let port =
        Unix.openfile Sys.argv.(1) [Unix.O_RDONLY; Unix.O_NOCTTY] 0o666 in
        print_loop port BYTE1 ;
      Unix.close port
    ) ;;


main();;


