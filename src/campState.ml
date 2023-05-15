open Card
open Player

type t = {
  health : bool;
  energy : bool;
  player : Player.t;
}

exception InvalidChoice of string

let create_camp p = { health = true; energy = true; player = p }

let pl_field p camp =
  let sh = player_cur_health p in
  let fh = 1.08 *. float_of_int sh in
  let potential_health =
    change_health_player p (int_of_float (Float.round fh))
  in
  if player_cur_health potential_health >= player_max_energy potential_health
  then change_health_player p 100
  else potential_health

let sleep_health camp =
  match camp.health with
  | true -> { camp with health = false; player = pl_field camp.player camp }
  | false -> raise (InvalidChoice "You can not sleep")

let gatorade_energy camp =
  match camp.energy with
  | true ->
      {
        camp with
        energy = false;
        player = Player.change_player_menergy camp.player 1;
      }
  | false -> raise (InvalidChoice "You can not drink gatorade")

let get_player_state c = c.player
let exists_energy c = c.energy
let exists_hp c = c.health
