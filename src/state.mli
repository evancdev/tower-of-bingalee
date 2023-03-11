type t
(** The abstract type of values representing the game state. *)

val init_state : Enemy.t -> t
(***)

val play : string -> t -> t
(**plays the card*)

val end: string -> t
(**ends the turn*)

val checkhand : t -> string list 
(**returns player hand*)