open Game
open State
open Card
open Command

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let card_database = create_cards card_json

let display_battle_field (state : State.t) =
  let healths = get_healths state in
  let ph = fst healths in
  let eh = snd healths in
  if ph <= 0 then (
    print_endline "\n\t💀: 0💔";
    print_endline ("\n\t👾: " ^ string_of_int eh ^ "💚\n\n"))
  else if eh <= 0 then (
    print_endline ("\n\t🧑: " ^ string_of_int ph ^ "🧡");
    print_endline "\n\t💀: 0💔\n\n")
  else (
    print_endline ("\n\t🧑: " ^ string_of_int ph ^ "🧡");
    print_endline ("\n\t👾: " ^ string_of_int eh ^ "💚\n\n"))

let enemy_turn (state : State.t) =
  if game_state state = EnemyDead then (
    display_battle_field state;
    ANSITerminal.print_string
      [ ANSITerminal.blue; ANSITerminal.Bold ]
      "You won! Thanks for playing!\n";
    raise (Failure "enemy dead"))
  else
    ANSITerminal.print_string
      [ ANSITerminal.red; ANSITerminal.Underlined ]
      "Enemy slime hit for 5 damage.\n";
  let new_state = enemy_attacks state in
  if game_state new_state = PlayerDead then (
    display_battle_field new_state;
    ANSITerminal.print_string
      [ ANSITerminal.red; ANSITerminal.Bold ]
      "You lost! Thanks for playing!\n";
    raise (Failure "player dead"))
  else new_state

let try_play (state : State.t) (card : string) =
  match play_card card_database card state with
  | exception CardNotInHand c -> raise (CardNotInHand c)
  | s ->
      ANSITerminal.print_string
        [ ANSITerminal.green; ANSITerminal.Underlined ]
        ("You played " ^ card ^ ".\n");
      s

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
          ANSITerminal.print_string
            [ ANSITerminal.red; ANSITerminal.Underlined ]
            (c ^ " not in hand.\n");
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
