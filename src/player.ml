open Yojson.Basic.Util

type t = {
  health : int;
  block : int;
  energy : int;
  player_hand : list;
}

let player_health pl = pl.health
let player_block pl = raise (Failure "Unimplemented: Player.player_block")
let player_hand pl = raise (Failure "Unimplemented: Player.player_hand")
let player_energy pl = raise (Failure "Unimplemented: Player.player_health")

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
