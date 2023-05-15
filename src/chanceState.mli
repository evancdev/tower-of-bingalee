type t
type prompt
type change

val prompt_desc : string
val read_decision : string -> bool
val get_player_state : t -> Player.t
