type t
(** The abstract type of values representing player. *)

val create_player : string -> t

val player_health : t -> int
(**[player_health] returns the player's maximum health*)

val player_cur_health : t -> int
(**[player_health] returns the player's current health*)

val player_energy : t -> int
(**[player_energy] returns the player's maximum energy*)

val player_cards : t -> string list
(**[player_cards] returns all the cards that the player has*)

val player_stage : t -> int * int
(**[player_stage] returns the player's current stage (floor, depth)*)

val add_card : t -> string -> t
(**[add_card] adds card [c] to the player's card collection*)

val p_remove_card : t -> string -> t
(**[remove_card] removes the string [card_name] from the a list*)

val change_health_player : t -> int -> bool -> t
(**modifies player health*)

val change_gold_player : t -> int -> t
(**modifies player gold*)

val change_energy_player : t -> int -> bool -> t
(**modifies player energy*)
