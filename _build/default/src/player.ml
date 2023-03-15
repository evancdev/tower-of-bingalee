type t
(**player*)

(**get player health*)
let player_health (p : t) : int = raise (Failure "unimplemented player_health")

(**get palyer block*)
let player_block (p : t) : int = raise (Failure "unimplemented player_block")

(**name of cards player is holding*)
let player_hand (p : t) : string list =
  raise (Failure "unimplemented player_hand")

(**player energy*)
let player_energy (p : t) : int = raise (Failure "unimplemented player_health")
