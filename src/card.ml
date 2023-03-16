open Yojson.Basic.Util

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

type card = {
  id : string;
  description : string;
  energy : int;
  damage : int;
  block : int;
  effect : int;
}

type t = { cards : card list }
(** The abstract type of values representing cards. *)

type effect = unit
(**effect*)

let card_of_json j =
  {
    id = j |> member "id" |> to_string;
    description = j |> member "description" |> to_string;
    energy = j |> member "energy" |> to_int;
    damage = j |> member "damage" |> to_int;
    block = j |> member "block" |> to_int;
    effect = j |> member "effect" |> to_int;
  }

let all_cards_of_json j =
  j |> member "cards" |> to_list |> List.map card_of_json

let rec card_description (lst : card list) (c : string) =
  match lst with
  | [] -> raise (UnknownCard "Not a valid card.")
  | h :: t -> if h.id = c then h.description else card_description t c

(** [create_card j] is the set of cards that [j] represents. Requires: [j] is a
    valid JSON card representation. *)
let create_cards j = { cards = all_cards_of_json j }

(** [description a c] is the description of the card with identifier [c] in list
    of cards [a]. Raises [UnknownCard c] if [c] is not a card identifier in [a]. *)

let description (c : t) (desc : string) = c.cards |> card_description
let get_dmg = raise (Failure "unimplemented")
let get_energy = raise (Failure "unimplemented")
let get_block = raise (Failure "unimplemented")
let get_effect = raise (Failure "unimplemented")
