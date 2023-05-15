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
  Player.change_health_player p (int_of_float (Float.round fh)) false
  
let sleep_health camp = match camp.health with 
| true -> {camp with health = false ; player = pl_field camp.player camp}
|false -> raise (InvalidChoice "You can not sleep")

let gatorade_energy camp = match camp.energy with 
| true -> {camp with energy = false ; player = Player.change_energy_player camp.player 1 false}
|false -> raise (InvalidChoice "You can not drink gatorade")


(* heals 8% if they decide to sleep gives them 1 energy if they choose energy *)
let get_player_state c = c.player
