type t
(** The abstract type representing an enemy *)

val enemy_health : t -> int
(**[enemy block e] is the amount of health [e] has *)

val enemy_block : t -> int
(** [enemy block e] is the amount of damage [e] can block*)
