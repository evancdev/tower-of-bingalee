open Card

type t = {
  name : string;
  health : int;
  energy : int;
  block : int;
  hand : Card.t list;
  deck : Card.t list;
}

(**[player_health] returns the player's current health*)
let player_health (p : t) : int = p.health

(**[player_block] returns the player's current block*)
let player_block (p : t) : int = p.block

let add_card_name (card : Card.t) lst = card.id :: lst

(**[player_hand] returns the player's current hand*)
let player_hand (p : t) : string list = List.fold_right add_card_name p.hand []

(**[player_energy] returns the player's current energy*)
let player_energy (p : t) : int = p.energy

(**[add_card] adds card [c] to the player's deck*)
let add_card (c : Card.t) = { t with deck = deck @ [ c ] }
