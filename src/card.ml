open Yojson.Basic.Util

exception UnknownCard of string

type card = {
  id : string;
  description : string;
  energy : int;
  damage : int;
  block : int;
  value : int;
  tier : int;
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
    value = j |> member "value" |> to_int;
    tier = j |> member "tier" |> to_int;
  }

let all_cards_of_json j =
  j |> member "cards" |> to_list |> List.map card_of_json

let rec card_description (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.description else card_description c t

let rec card_value (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.value else card_value c t

let rec card_tier (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.tier else card_tier c t

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

let rec card_id (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.id else card_id c t

let rec card_tier (c : string) (lst : card list) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.tier else card_tier c t

let create_cards j = { cards = all_cards_of_json j }
let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let set = create_cards card_json
let description (card : string) = set.cards |> card_description card
let get_dmg (card : string) = set.cards |> card_dmg card
let get_energy (card : string) = set.cards |> card_energy card
let get_block (card : string) = set.cards |> card_block card
let get_id (card : string) (lst : card list) = card_id card lst
let get_tier (card : string) = set.cards |> card_tier card
let is_t1 card = if card.tier = 1 then true else false
let is_t2 card = if card.tier = 2 then true else false
let is_t3 card = if card.tier = 3 then true else false
let t1_cards j = all_cards_of_json j |> List.filter is_t1
let t2_cards j = all_cards_of_json j |> List.filter is_t2
let t3_cards j = all_cards_of_json j |> List.filter is_t3
