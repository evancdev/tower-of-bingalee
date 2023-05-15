open Card
open Player
open Random
open Yojson.Basic.Util

exception InvalidPrompt of string

type t = { player : Player.t }

type change = {
  health_delta : int;
  energy_delta : int;
  gold_delta : int;
}

type prompt = {
  choice : bool;
  changes : change list;
  description : string;
}

let prompt_of_json (j : Yojson.Basic.t) = failwith "Unimpl."
let generate_random_prompt = List.nth prompts (Random.int (List.length prompts))

let apply_changes (state : t) (change : change) =
  change_player_menergy
    (change_gold_player
       (change_player_mhp state.player change.health_delta)
       change.gold_delta)
    change.energy_delta

let read_decision (prompt : prompt) =
  let rec loop () =
    ANSITerminal.(print_string [ green ] (prompt.description ^ "\n"));
    ANSITerminal.(print_string [ yellow ] "Enter your choice (y/n): ");
    match String.trim (read_line ()) with
    | "y" | "Y" -> true
    | "n" | "N" -> false
    | _ ->
        ANSITerminal.(
          print_string [ red ] "Invalid choice. Please enter 'y' or 'n'.\n");
        loop ()
  in
  loop ()

let apply_prompt (state : t) (p : prompt) =
  if p.choice then
    match read_decision p with
    | true -> apply_changes state (List.nth p.changes 0)
    | false -> apply_changes state (List.nth p.changes 1)
  else apply_changes state (List.nth p.changes 0)

let get_player_state (state : t) = state.player
