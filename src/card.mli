(** Module for managing information about each card, as well as a database of
    cards and their information*)

type t
(** The abstract type of values representing card decks, useful in testing a
    card database, but not for the actual game. *)

type card
(** The abstract type representing a single card.*)

type effect
(**secondary effect playing a card may have*)

val create_cards : Yojson.Basic.t -> t
(** [create_card j] is the adventure that [j] represents. Requires: [j] is a
    valid JSON card representation. *)

exception UnknownCard of string
(** Raised when an unknown card identifier is encountered. It carries the
    identifier of the unknown card. *)

val description : string -> string
(** [description a c] is the description of the card with identifier [c] in list
    of cards [a]. Raises [UnknownCard c] if [c] is not a card identifier in [a]. *)

val get_card_name : card -> string
(**[get_card_name c] returns the name of a card given the card object*)

val get_dmg : string -> int
val description : string -> string
val get_dmg : string -> int
val get_energy : string -> int
val get_block : string -> int
val get_id : string -> string
val get_tier : string -> int
val get_bdmg : string -> int
val get_blck : string -> int
val get_synergy : string -> string list
val get_value : string -> int
val t1_cards : string list
val t2_cards : string list
val t3_cards : string list
val find_card : string -> card
