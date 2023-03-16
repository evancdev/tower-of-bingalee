open Yojson.Basic.Util

exception UnknownCard of string

type card = {
  id : string;
  description : string;
  energy : int;
  damage : int;
  block : int;
}

type t = { cards : card list }
type effect = unit

let card_of_json j =
  {
    id = j |> member "id" |> to_string;
    description = j |> member "description" |> to_string;
    energy = j |> member "energy" |> to_int;
    damage = j |> member "damage" |> to_int;
    block = j |> member "block" |> to_int;
  }

let all_cards_of_json j =
  j |> member "cards" |> to_list |> List.map card_of_json

let rec card_description (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.description else card_description c t

let rec card_dmg (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.damage else card_dmg c t

let rec card_energy (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.energy else card_energy c t

let rec card_block (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.block else card_block c t

let create_cards j = { cards = all_cards_of_json j }
let description (set : t) (card : string) = set.cards |> card_description card
let get_dmg (set : t) (card : string) = set.cards |> card_dmg card
let get_energy (set : t) (card : string) = set.cards |> card_energy card
let get_block (set : t) (card : string) = set.cards |> card_block card
let get_effect = raise (Failure "unimplemented")
