type t
type prompt
type change

val prompt_desc : prompt -> string
val read_decision : string -> bool
val get_player_state : t -> Player.t
