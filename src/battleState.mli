type t

exception CardNotInHand of string
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

val get_healths : t -> int * int
(**returns player hand*)

val get_card_state : t -> string list * string list
val activate_card : t -> string -> t
val get_player_state : t -> Player.t
