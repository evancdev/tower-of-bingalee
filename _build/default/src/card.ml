type t = unit
(** The abstract type of values representing cards. *)

type effect = unit
(**effect*)

(** [create_card j] is the adventure that [j] represents. Requires: [j] is a
    valid JSON card representation. *)
let create_card = raise (Failure "unimplemented")

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

(** [description a c] is the description of the card with identifier [c] in list
    of cards [a]. Raises [UnknownCard c] if [c] is not a card identifier in [a]. *)
let description (c : t) (str : string) : string =
  raise (Failure "unimplemented")

let get_dmg = raise (Failure "unimplemented")
let get_energy = raise (Failure "unimplemented")
let get_block = raise (Failure "unimplemented")
let get_effect = raise (Failure "unimplemented")
