type t
(** The abstract type representing an enemy *)

val enemy_health : t -> int
(**[enemy_block e] is the amount of health [e] has *)

val enemy_gold : t -> int
(** [enemy_gold e] is the amount of gold [e] can drop*)

val enemy_damage : t -> int
(**[enemy_damage e] is the amount of damage [e] can do *)

val enemy_name : t -> string
(**[enemy_name e] is the name of [e] *)

val enemy_face : t -> string
(**[enemy_face e] is the face of [e] *)

val init_enemy : int -> t
(** [init_enemy s] is the Enemy.t representing a newly born enemy with name [s]
    with stats drawn from the enemy.json database *)

val change_health_enemy : t -> int -> t
(**[change_health e i] is the amount of health [e] has after the user deals [i]
   damage*)
