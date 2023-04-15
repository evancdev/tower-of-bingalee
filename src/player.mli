type t
(** The abstract type of values representing player. *)

val create_player : string -> t

val player_health : t -> int
(**[player_health] returns the player's current health*)

val player_block : t -> int
(**[player_block] returns the player's current block*)

val player_hand : t -> string list
(**[player_hand] returns the player's current hand*)

val player_energy : t -> int
(**[player_energy] returns the player's current energy*)

val add_card : t -> string -> t
(**[add_card] adds card [c] to the player's deck*)

val remove_card : string -> string list -> int -> string list
(**[remove_card] removes the string [card_name] from the a list*)

val draw : t -> t
(**[draw] updates the player's field whenever he draws*)

val change_health_player : t -> int -> t
(**modifies player health*)
