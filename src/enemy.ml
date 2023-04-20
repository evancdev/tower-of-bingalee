open Yojson.Basic.Util

exception UnknownEnemy of string

type t = {
  name : string;
  health : int;
  block : int;
  damage : int;
  cards : string list;
}

let enemy_of_json j =
  {
    name = j |> member "name" |> to_string;
    health = j |> member "health" |> to_int;
    block = j |> member "block" |> to_int;
    damage = j |> member "damage" |> to_int;
    cards = [];
  }

let enemy_database =
  let data_dir_prefix = "data" ^ Filename.dir_sep in
  let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json") in
  enemy_json |> member "enemies" |> to_list |> List.map enemy_of_json

let init_enemy (enemy_name : string) =
  let found = List.find (fun e -> e.name = enemy_name) enemy_database in
  match found with
  | exception Not_found -> raise (UnknownEnemy enemy_name)
  | e -> e

let change_health t damage = { t with health = t.health - damage }
let change_block t = raise (Failure "Unimplemented")
let enemy_health t = t.health
let enemy_block t = t.block
let enemy_damage t = t.damage
