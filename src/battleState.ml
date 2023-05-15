open Player
open Enemy
open Card
open Command
open Printf
open UsefulFunctions

exception CardNotInHand of string

type t = {
  player : Player.t;
  enemy : Enemy.t;
  max_hp : int;
  max_energy : int;
  cur_hp : int;
  cur_energy : int;
  block : int;
  deck : string list;
  used_cards : string list;
  hand : string list;
  active : string list;
  hold : string option;
}
(** The abstract type of values representing the game state. *)

let init_battle (p : Player.t) (enemy_tier : int) =
  {
    player = p;
    enemy = init_enemy enemy_tier;
    max_hp = player_health p;
    cur_hp = player_cur_health p;
    max_energy = player_max_energy p;
    cur_energy = 3;
    block = 0;
    deck = player_cards p;
    used_cards = [];
    hand = [];
    active = [];
    hold = None;
  }

let rec eval_active (state : t) =
  match state.active with
  | [] -> state
  | h :: t ->
      if t = [] then
        { state with enemy = change_health_enemy state.enemy (get_dmg h) }
      else eval_active state

(**plays the card*)
(*let play_card (card_database : Card.t) (card_name : string) (state : t) = if
  List.mem card_name (player_hand state.player) then let new_enemy_state =
  card_name |> get_dmg |> change_health state.enemy in (* print_endline
  (string_of_int (enemy_health new_enemy_state)); *) { state with enemy =
  new_enemy_state } else raise (CardNotInHand card_name)*)

(**returns player hand*)
let checkhand (state : t) = state.hand

type status =
  | Alive
  | PlayerDead
  | EnemyDead

let game_state (state : t) =
  if player_health state.player <= 0 then PlayerDead
  else if enemy_health state.enemy <= 0 then EnemyDead
  else Alive

let enemy_attacks (state : t) =
  {
    state with
    player = change_player_mhp state.player (enemy_damage state.enemy);
  }

let hold_card (state : t) (card : string) : t = { state with hold = Some card }

let new_deck (deck : string list) (held_card : string option) : string list =
  match held_card with
  | None -> List.filteri (fun i _ -> i > 4) deck
  | Some card -> List.filteri (fun i _ -> i > 3) deck

let new_hand (deck : string list) (held_card : string option) : string list =
  match held_card with
  | None -> List.filteri (fun i _ -> i <= 4) deck
  | Some card -> card :: List.filteri (fun i _ -> i <= 3) deck

let no_more_cards (p : t) : t =
  let deck2 = p.deck @ shuffle p.used_cards in
  {
    p with
    hand = new_hand deck2 p.hold;
    deck = new_deck deck2 p.hold;
    used_cards = [];
  }

let draw (p : t) : t =
  match p.hold with
  | None when List.length p.deck < 5 -> no_more_cards p
  | Some _ when List.length p.deck < 4 -> no_more_cards p
  | _ -> { p with hand = new_hand p.deck p.hold; deck = new_deck p.deck p.hold }

let get_healths (state : t) =
  (player_health state.player, enemy_health state.enemy)
