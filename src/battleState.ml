open Player
open Enemy
open Card
open Command
open Printf

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
}
(** The abstract type of values representing the game state. *)

let init_battle (p : Player.t) (enemy_tier : int) =
  {
    player = p;
    enemy = init_enemy enemy_tier;
    max_hp = player_health p;
    cur_hp = player_cur_health p;
    max_energy = player_energy p;
    cur_energy = player_energy p;
    block = 0;
    deck = player_cards p;
    used_cards = [];
    hand = [];
    active = [];
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
    player = change_health_player state.player (enemy_damage state.enemy) true;
  }

let get_healths (state : t) =
  (player_health state.player, enemy_health state.enemy)
