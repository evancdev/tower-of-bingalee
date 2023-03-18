(** TODO: takes in the state of the battle field and prints it*)
let display_battle_field () =
  print_endline "\n\t🧑\t    👾";
  print_endline "\n    🧡10/10\t  💚5/10"

let print_instructions () =
  ANSITerminal.print_string
    [ ANSITerminal.green; ANSITerminal.Underlined ]
    "\n=== Instructions for Gaming ===\n";
  print_endline "\n   play <card>: plays the card with name <card> in your deck";
  print_endline "\n   quit : quits the game"

let rec cmd_loop () =
  print_endline "Enter a command or help for instructions.\n";
  print_string "> ";
  match read_line () with
  | exception End_of_file -> ()
  | "help" -> print_instructions ()
  | "quit" -> ANSITerminal.print_string [ ANSITerminal.green ] "\nBye shawty.\n"
  | _ ->
      ANSITerminal.print_string [ ANSITerminal.red ] "\nUnknown command.\n";
      cmd_loop ()

let main () =
  ANSITerminal.print_string [ ANSITerminal.cyan ] "\n\nA slime approaches.\n";
  display_battle_field ();
  match () with
  | () -> cmd_loop ()

let () = main ()
