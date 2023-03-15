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
