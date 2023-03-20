type t
(** The abstract type representing an enemy *)

val enemy_health : t -> int
(**[enemy block e] is the amount of health [e] has *)

val enemy_block : t -> int
(** [enemy block e] is the amount of damage [e] can block*)

val init_enemy : string -> t
(** [init_enemy s] is the Enemy.t representing a newly born enemy with name [s]
    with stats drawn from the enemy.json database *)

val change_health : t -> int -> t
