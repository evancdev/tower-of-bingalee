open Yojson.Basic.Util
open Card

type t = {
  health : int;
  block : int;
  energy : int;
  player_hand : string list;
}

let init_player card = Failure "unimplemented init_player"

(**get player health*)
let player_health (p : t) : int = raise (Failure "unimplemented player_health")

(**get palyer block*)
let player_block (p : t) : int = raise (Failure "unimplemented player_block")

(**name of cards player is holding*)
let player_hand (p : t) : string list =
  raise (Failure "unimplemented player_hand")

(**player energy*)
let player_energy (p : t) : int = raise (Failure "unimplemented player_health")
