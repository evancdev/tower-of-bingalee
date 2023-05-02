type t

exception CardNotInHand of string
(** The abstract type of values representing the game state. *)

val init_battle : Player.t -> string -> t
(***)

val play_card : Card.t -> string -> t -> t
(**plays the card*)

val checkhand : t -> string list

type status =
  | Alive
  | PlayerDead
  | EnemyDead

val game_state : t -> status
(**returns player hand*)

val enemy_attacks : t -> t

val get_healths : t -> int * int
(**returns player hand*)
