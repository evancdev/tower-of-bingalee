type t
(** The abstract type of values representing cards. *)

type card

val create_cards : Yojson.Basic.t -> t
(** [create_card j] is the adventure that [j] represents. Requires: [j] is a
    valid JSON card representation. *)

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

val description : string -> string
(** [description s] is the description of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)

val get_card_name : card -> string
(** [get_card_name c] is the name of [c]. *)

val get_dmg : string -> int
(** [get_damage s] is the damage of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)

val get_energy : string -> int
(** [get_energy s] is the energy of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)

val get_block : string -> int
(** [get_block s] is the block of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)

val get_id : string -> string
(** [get_id s] is the id of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)

val get_tier : string -> int
(** [get_tier s] is the description of the card with identifier [s] in 
    the cards. Raises [UnknownCard s] if [s] is not a card identifier. *)
val get_bdmg : string -> int
val get_blck : string -> int
val get_synergy : string -> string list
val get_value : string -> int
val t1_cards : string list
val t2_cards : string list
val t3_cards : string list
val find_card : string -> card
