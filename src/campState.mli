type t
(**representation of a camp*)

exception InvalidChoice of string

val create_camp : Player.t -> t
(**creates a camp based on the current floor and depth*)

val sleep_health : t -> t
(** [sleep_health p c] is the health player [p] gets after they choose to sleep
    in camp [c]*)

val gatorade_energy : t -> t
(** [gatorade_energy p c] is the energy player [p] gets after they choose to
    drink a gatorade in camp [c]*)

val get_player_state : t -> Player.t
(**gets the player state*)

val exists_energy : t -> bool
(** [camp_energy c] is the energy availability of [c]*)

val exists_hp : t -> bool
(** [camp_health c] is the health availability of [c]*)

val stats : t -> string
