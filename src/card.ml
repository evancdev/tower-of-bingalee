type t = unit
(** The abstract type of values representing cards. *)

type effect
(**effect*)

let create_card ( j : Yojson.Basic.t ): t = ()
(** [create_card j] is the adventure that [j] represents. Requires: [j] is a 
    valid JSON card representation. *)

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

let description : string = raise (Failure "unimplemented")
(** [description a c] is the description of the card with identifier [c] in
    list of cards [a]. Raises [UnknownCard c] if [c] is not a card identifier in
    [a]. *)
let get_dmg : int = raise (Failure "unimplemented")

let get_energy : int = raise (Failure "unimplemented")

let get_block : int = raise (Failure "unimplemented")

let get_effect = raise (Failure "unimplemented")
