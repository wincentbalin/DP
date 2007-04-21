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
  HOLD | DELTA | OHM | FARAD | BATT | HERTZ | VOLT | AMPERE | HFE | CELSIUS ;;


(* Variables. *)
let screen = Hashtbl.create 54 ;;


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


(* Print digit with given segment bits. *)
let print_digit sb1 sb2 sb3 sb4 sb5 sb6 sb7 =
  let s1 = Hashtbl.find screen sb1
  and s2 = Hashtbl.find screen sb2
  and s3 = Hashtbl.find screen sb3
  and s4 = Hashtbl.find screen sb4
  and s5 = Hashtbl.find screen sb5
  and s6 = Hashtbl.find screen sb6
  and s7 = Hashtbl.find screen sb7 in
  let digit = segments_to_digit s1 s2 s3 s4 s5 s6 s7 in
  print_char digit ;;


(* Print period if it is there. *)
let print_period sb =
  let period = Hashtbl.find screen sb in
  match period with
    | 1 -> print_char '.'
    | _ -> () ;;


(* Prints acquired data on screen. *)
let print_data () =
  (* Print sign if it is there. *)
  let sign_bit = Hashtbl.find screen SIGN in
  let sign = if sign_bit = 1 then '-' else ' ' in
  print_char sign;
  (* Print first digit. *)
  print_digit A1 A2 A3 A4 A5 A6 A7;
  (* Print first point if it is there. *)
  print_period P1;
  (* Print second digit. *)
  print_digit B1 B2 B3 B4 B5 B6 B7;
  (* Print second point if it is there. *)
  print_period P2;
  (* Print third digit. *)
  print_digit C1 C2 C3 C4 C5 C6 C7;
  (* Print third point if it is there. *)
  print_period P3;
  (* Print fourth digit. *)
  print_digit D1 D2 D3 D4 D5 D6 D7;
  (* Print separator. *)
  print_char ' ';
  (* Print multiplier. *)
  let nano = Hashtbl.find screen NANO
  and micro = Hashtbl.find screen MICRO
  and milli = Hashtbl.find screen MILLI
  and kilo = Hashtbl.find screen KILO
  and mega = Hashtbl.find screen MEGA in
  let multiplier =
  match (nano, micro, milli, kilo, mega) with
    | (1, 0, 0, 0, 0) -> 'n'
    | (0, 1, 0, 0, 0) -> 'u'
    | (0, 0, 1, 0, 0) -> 'm'
    | (0, 0, 0, 1, 0) -> 'K'
    | (0, 0, 0, 0, 1) -> 'M'
    | _ -> ' ' in
  print_char multiplier;
  (* Print unit. *)
  let diode = Hashtbl.find screen DIODE
  and ton = Hashtbl.find screen TON
  and percent = Hashtbl.find screen PERCENT
  and farad = Hashtbl.find screen FARAD
  and ohm = Hashtbl.find screen OHM
  and volt = Hashtbl.find screen VOLT
  and ampere = Hashtbl.find screen AMPERE
  and hertz = Hashtbl.find screen HERTZ
  and celsius = Hashtbl.find screen CELSIUS
  and hfe = Hashtbl.find screen HFE in
  let measuring_unit =
  match (diode, ton, percent, farad, ohm,
    volt, ampere, hertz, celsius, hfe) with
    | (1, 0, 0, 0, 0, 0, 0, 0, 0, 0) -> "Diode"
    | (0, 1, 0, 0, 0, 0, 0, 0, 0, 0) -> "Ton"
    | (0, 0, 1, 0, 0, 0, 0, 0, 0, 0) -> "%"
    | (0, 0, 0, 1, 0, 0, 0, 0, 0, 0) -> "F"
    | (0, 0, 0, 0, 1, 0, 0, 0, 0, 0) -> "Ohm"
    | (0, 0, 0, 0, 0, 1, 0, 0, 0, 0) -> "V"
    | (0, 0, 0, 0, 0, 0, 1, 0, 0, 0) -> "A"
    | (0, 0, 0, 0, 0, 0, 0, 1, 0, 0) -> "Hz"
    | (0, 0, 0, 0, 0, 0, 0, 0, 1, 0) -> "°C"
    | (0, 0, 0, 0, 0, 0, 0, 0, 0, 1) -> "HFE"
    | _ -> "" in
  print_string measuring_unit;
  (* Print big separator. *)
  print_char '\t';
  (* Print auto-range. *)
  let autorange = Hashtbl.find screen AUTO in
  match autorange with
    | 1 -> print_string "Auto-range\t"
    | _ -> () ;
  (* Print hold. *)
  let hold = Hashtbl.find screen HOLD in
  match hold with
    | 1 -> print_string "Hold\t"
    | _ -> () ;
  (* Print relative measurement. *)
  let delta = Hashtbl.find screen DELTA in
  match delta with
    | 1 -> print_string "Relative measurement.\t"
    | _ -> () ;
  (* Print AC/DC. *)
  let ac = Hashtbl.find screen AC
  and dc = Hashtbl.find screen DC in
  let acdc =
  match (ac, dc) with
    | (1, 0) -> "AC measuring\t"
    | (0, 1) -> "DC measuring\t"
    | _ -> "" in
  print_string acdc ;
  (* Print low battery. *)
  let low_batt= Hashtbl.find screen BATT in
  match low_batt with
    | 1 -> print_string "Low battery!\t"
    | _ -> () ;
  (* Go to the next line and flush output. *)
  print_newline () ;;


(* Store specified bit in a screen segment. *)
let store_bit_in_segment data shift segment =
  let bit = (data lsr shift) land 1 in
  Hashtbl.replace screen segment bit ;;


(* Process given data and return next state. *)
let process_data data_byte state =
  let data = int_of_char (String.get data_byte 0) in
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
      store_bit_in_segment data 1 HERTZ;
      store_bit_in_segment data 2 VOLT;
      store_bit_in_segment data 3 AMPERE;
      BYTE14
    | BYTE14 when byte_number = 14 ->
      store_bit_in_segment data 1 HFE;
      store_bit_in_segment data 2 CELSIUS;
      print_data ();
      BYTE1
    | _ -> BYTE1 ;;


(* If a key pressed, cancel program. *)
let cancel_on_key state =
  let buf = " " in
  try
  (
    (* Prepare polling on standard input. *)
    Unix.set_nonblock Unix.stdin ;
    let read_chars = Unix.read Unix.stdin buf 0 1 in
    Unix.clear_nonblock Unix.stdin ; 
    match read_chars with
      | 1 -> EXIT
      | _ -> state
  )
  with Unix.Unix_error (e, fm, argm) ->
    if e = Unix.EAGAIN || e = Unix.EWOULDBLOCK then state
    else EXIT ;;


(* Loop which reads data from serial port and prints. *)
let rec print_loop port state =
  let buf = " " in
  let _ = Unix.read port buf 0 1 in    (* Read one character. *)
  let next_state = process_data buf state in  (* And process it. *)
  let next_state = cancel_on_key next_state in (* If a key pressed, exit. *)
  match next_state with
    | EXIT -> () 
    | _ -> print_loop port next_state ;;    (* Tail recursion. *)


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
      try
      (
        (* Open file and process data. *)
        let port =
          Unix.openfile Sys.argv.(1) [Unix.O_RDONLY; Unix.O_NOCTTY] 0o666 in
        let serial_opts = Unix.tcgetattr port in
        serial_opts.Unix.c_ibaud <- 2400 ;
	serial_opts.Unix.c_csize <- 8 ;
	serial_opts.Unix.c_clocal <- true ;
	serial_opts.Unix.c_cread <- true ;
	serial_opts.Unix.c_ignpar <- true ;
	serial_opts.Unix.c_vmin <- 1 ;
	serial_opts.Unix.c_vtime <- 20 ;
	Unix.tcflush port Unix.TCIFLUSH ;
        Unix.tcsetattr port Unix.TCSANOW serial_opts ;
        print_loop port BYTE1 ;
        Unix.close port
      )
      (* Redo functionality of Unix.handle_unix_error. *)
      with Unix.Unix_error (e, fm, argm) ->
        prerr_endline ((Unix.error_message e) ^ " " ^ fm ^ " " ^ argm)
    ) ;;

main () ;;


