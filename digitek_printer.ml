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
  HOLD | DELTA | OHM | FARAD | BATT | HZ | VOLT | AMPERE | HFE | CELSUIS;;


(* Variables. *)
let screen = Hashtbl.create 54;;


(* Functions. *)

(* Convert segments to a digit. *)
let segments_to_digit s1 s2 s3 s4 s5 s6 s7 =
  match [s1; s2; s3; s4; s5; s6; s7] with
    | [true; true; true; true; true; true; false] -> '0'
    | [false; true; true; false; false; false; false] -> '1'
    | [true; true; false; true; true; false; true] -> '2'
    | [true; true; true; true; false; false; true] -> '3'
    | [false; true; true; false; false; true; true] -> '4'
    | [true; false; true; true; false; true; true] -> '5'
    | [true; false; true; true; true; true; true] -> '6'
    | [true; true; true; false; false; false; false] -> '7'
    | [true; true; true; true; true; true; true] -> '8'
    | [true; true; true; true; false; true; true] -> '9'
    | [false; false; false; true; true; true; true] -> 'L'
    | [false; false; false; false; false; false; false] -> ' '
    | _ -> 'X' ;;


(* Process given data and return next state. *)
let process_data data_byte state =
  let data = int_of_string data_byte in
  let byte_number = data lsr 4 in
  match state with
    | BYTE1 when byte_number = 1 ->
      let rs232_bit = data land 1 in
        Hashtbl.replace screen RS232 rs232_bit ;
(*      let auto_bit = (data *)
      BYTE2
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
      let port = Unix.openfile Sys.argv.(1) [Unix.O_RDONLY; Unix.O_NOCTTY] 0o666 in
        print_loop port BYTE1 ;
      Unix.close port
    ) ;;

main();;


