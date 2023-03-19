open Game
open State
open Card
open Command

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let card_database = create_cards card_json

let enemy_turn (state : State.t) =
  if game_state state = EnemyDead then raise (Failure "enemy dead")
  else
    let new_state = enemy_attacks state in
    if game_state new_state = PlayerDead then raise (Failure "player dead")
    else new_state

let try_play (state : State.t) (card : string) =
  play_card card_database card state

(** TODO: takes in the state of the battle field and prints it*)
let display_battle_field (state : State.t) =
  let healths = get_healths state in
  let ph = string_of_int (fst healths) in
  let eh = string_of_int (snd healths) in
  print_endline ("\n\t🧑: " ^ ph ^ "🧡");
  print_endline ("\n\t👾: " ^ eh ^ "💚\n\n")

let print_instructions () =
  ANSITerminal.print_string
    [ ANSITerminal.green; ANSITerminal.Underlined ]
    "\n=== Instructions for Gaming ===\n";
  print_endline "\n   play <card>: plays the card with name <card> in your deck";
  print_endline "\n   quit : quits the game"

let rec cmd_loop (state : State.t) =
  display_battle_field state;
  print_endline "Enter a command:\n";
  print_string "> ";
  match read_line () with
  | exception End_of_file -> ()
  | s -> match_cmd state s

and match_cmd (state : State.t) (input : string) =
  match parse input with
  | Play c -> (
      match c |> String.concat " " |> try_play state with
      | s -> (
          match enemy_turn s with
          | exception Failure death -> ()
          | new_state -> cmd_loop new_state)
      | exception CardNotInHand c ->
          print_endline (c ^ " not in hand.");
          cmd_loop state)
  | CheckHand ->
      display_battle_field state;
      cmd_loop state
  | End -> ()
  | exception exn ->
      print_endline "Invalid command.";
      cmd_loop state

let main () =
  ANSITerminal.print_string [ ANSITerminal.cyan ] "\n\nWelcome to the game!\n";
  cmd_loop (init_state "Player1" "slime")

let () = main ()
