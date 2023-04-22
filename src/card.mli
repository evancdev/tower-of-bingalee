type t
(** The abstract type of values representing cards. *)

type card

type effect
(**effect*)

val create_cards : Yojson.Basic.t -> t
(** [create_card j] is the adventure that [j] represents. Requires: [j] is a
    valid JSON card representation. *)

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

val description : string -> string
(** [description a c] is the description of the card with identifier [c] in list
    of cards [a]. Raises [UnknownCard c] if [c] is not a card identifier in [a]. *)

val get_dmg : string -> int
val get_energy : string -> int
val get_block : string -> int
val get_effect : string -> effect
val get_id : card -> string
