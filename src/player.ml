type t = {
  name : string;
  health : int;
  energy : int;
  block : int;
  hand : string list;
  deck : string list;
}

let create_player (name : string) =
  {
    name;
    health = 50;
    energy = 3;
    block = 0;
    hand = [ "OMEGA attack"; "baby attack"; "zero attack"; "OMEGA attack" ];
    deck = [ "OMEGA attack"; "OMEGA attack"; "OMEGA attack"; "OMEGA attack" ];
  }

(**[player_health] returns the player's current health*)
let player_health (p : t) : int = p.health

(**[player_block] returns the player's current block*)
let player_block (p : t) : int = p.block

let add_card_name (card_id : string) lst : string list = card_id :: lst

(* let player_hand (p : t) = List.fold_right add_card_name p.hand [] *)

(**[player_hand] returns the player's current hand*)
let player_hand (p : t) = p.hand

(**[player_energy] returns the player's current energy*)
let player_energy (p : t) : int = p.energy

(**[add_card] adds [card_name] to the player's deck*)
let add_card (p : t) (card_name : string) =
  { p with deck = p.deck @ [ card_name ] }

let change_health_player t damage = { t with health = t.health - damage }
