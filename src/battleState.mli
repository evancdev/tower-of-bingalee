type t

exception CardNotInHand of string

exception NotEnoughEnergy
(** The abstract type of values representing the game state. *)

val init_battle : Player.t -> int -> t
(***)

val checkhand : t -> string list
val enemy_battle : t -> Enemy.t

type status =
  | Alive
  | PlayerDead
  | EnemyDead

val game_state : t -> status
(**returns player hand*)

val enemy_attacks : t -> t
val get_card_state : t -> string list * string list
val activate_card : t -> string -> t
val get_player_state : t -> Player.t
val eval_active : t -> t
val draw : t -> t
val reset_turn : t -> t
val gold_on_kill : t -> t
val get_health_strings : t -> string * string
val get_cur_energy : t -> int
