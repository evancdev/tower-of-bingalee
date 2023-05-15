type t
(** The abstract type of values representing player. *)

val create_player : unit -> t

val player_health : t -> int
(**[player_health] returns the player's maximum health*)

val player_cur_health : t -> int
(**[player_health] returns the player's current health*)

val player_max_energy : t -> int
(**[player_energy] returns the player's maximum energy*)

val player_gold : t -> int
(**[player_gold] returns the player's gold*)

val player_cards : t -> string list
(**[player_cards] returns all the cards that the player has*)

val player_gold : t -> int

val player_stage : t -> int * int
(**[player_stage] returns the player's current stage (floor, depth)*)

val add_card : t -> string -> t
(**[add_card] adds card [c] to the player's card collection*)

val p_remove_card : t -> string -> t
(**[remove_card] removes the string [card_name] from the a list*)

val change_player_mhp : t -> int -> t
(**modifies player health*)

val change_gold_player : t -> int -> t
(**modifies player gold*)

val change_player_menergy : t -> int -> t
(**modifies player energy*)

val change_player_curhp : t -> int -> t
(**modifies player current health*)

val player_from : int -> int -> string list -> int -> int -> int * int -> t
