open Player
open Enemy
open Card
open Command
open Printf

exception CardNotInHand of string
exception NotEnoughEnergy

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

type card = string
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

let get_card_state (state : t) = (state.active, state.hand)

let activate_card (s : t) (c : card) =
  let rec pluck_card hand removed =
    match hand with
    | [] -> raise (CardNotInHand (removed ^ "not in hand."))
    | h :: t -> if h = removed then t else h :: pluck_card t removed
  in
  let dE = Card.get_energy c in
  if dE <= s.cur_energy then
    {
      s with
      hand = pluck_card s.hand c;
      active = c :: s.active;
      cur_energy = s.cur_energy - dE;
    }
  else raise NotEnoughEnergy

let get_player_state (s : t) =
  Player.player_from s.max_hp s.max_energy
    (s.deck @ s.used_cards @ s.hand @ s.active)
    (player_gold s.player) s.cur_hp
