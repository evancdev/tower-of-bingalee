open UsefulFunctions
open Card

type t = {
  max_health : int;
  max_energy : int;
  cards : string list;
  gold : int;
  cur_health : int;
  stage : int * int;
}

let create_player =
  {
    max_health = 50;
    max_energy = 3;
    cards =
      [
        "block";
        "block";
        "block";
        "block";
        "strike";
        "strike";
        "strike";
        "strike";
        "strike";
        "clash";
      ];
    gold = 0;
    cur_health = 50;
    stage = (1, 0);
  }

let player_health (p : t) : int = p.max_health
let player_cur_health (p : t) : int = p.cur_health
let player_max_energy (p : t) : int = p.max_energy
let player_cards (p : t) : string list = p.cards
let player_stage (p : t) : int * int = p.stage

let add_card (p : t) (card_name : string) : t =
  { p with cards = p.cards @ [ get_id card_name ] }

let p_remove_card (p : t) (card_name : string) : t =
  { p with cards = remove_card p.cards card_name }

let change_player_mhp (p : t) (amount : int) : t =
  { p with max_health = p.max_health + amount }

let change_gold_player (p : t) (gold : int) : t =
  { p with gold = p.gold + gold }

let change_player_menergy (p : t) (amount : int) : t =
  { p with max_energy = p.max_energy + amount }
