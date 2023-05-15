type t
type prompt
type change

val prompt_desc : prompt -> string
val read_decision : t -> bool
val get_player_state : t -> Player.t
val create_chance_event : Player.t -> t
val apply_prompt : t -> Player.t
