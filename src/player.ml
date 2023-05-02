type t = {
  name : string;
  health : int;
  energy : int;
  block : int;
  cards : string list;
  gold : int;
}

let create_player (name : string) =
  {
    name;
    health = 50;
    energy = 3;
    block = 0;
    cards = [ "OMEGA attack"; "OMEGA attack"; "OMEGA attack"; "OMEGA attack" ];
    gold = 0;
  }

(**[player_health] returns the player's current health*)
let player_health (p : t) : int = p.health

(**[player_block] returns the player's current block*)
let player_block (p : t) : int = p.block

(**[player_hand] returns the player's current hand*)
let player_hand (p : t) = p.hand

(**[player_energy] returns the player's current energy*)
let player_energy (p : t) : int = p.energy

let player_cards (p : t) : string list = p.cards

let change_health_player (p : t) (amount : int) (subtract : bool) : t =
  match subtract with
  | true -> { p with health = p.health - amount }
  | false -> { p with health = p.health + amount }

let change_gold_player (p : t) (gold : int) : t =
  { p with gold = p.gold + gold }

let change_energy_player (p : t) (amount : int) (subtract : bool) : t =
  match subtract with
  | true -> { p with energy = p.energy - amount }
  | false -> { p with energy = p.energy + amount }
