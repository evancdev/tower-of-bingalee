open Card
open Player

type t = {
  health : bool;
  energy : bool;
  player : Player.t;
}
exception InvalidChoice of string
let create_camp p = {
  health = true; (**health is avaible*)
  energy = true;
  player = p;
}

let pl_field p camp =
  let sh = Player.player_health p in
  let fh = 1.08 *. float_of_int sh in
  change_player_mhp p (int_of_float (Float.round fh))
  
let sleep_health p camp = match camp.health with 
| true -> {camp with health = false ; player = pl_field p camp}
|false -> raise (InvalidChoice "You can not sleep")

let gatorade_energy p camp = match camp.energy with 
| true -> {camp with energy = false ; player = Player.change_player_menergy p 1}
|false -> raise (InvalidChoice "You can not drink gatorade")


(* heals 8% if they decide to sleep gives them 1 energy if they choose energy *)
let get_player_state c = c.player
