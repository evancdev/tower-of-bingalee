type t
(**player*)

val player_health: t -> int
(**get player health*)

val player_block: t -> int
(**get palyer block*)

val player_hand: t -> string list
(**name of cards player is holding*)

val player_energy: t -> int
(**player energy*)