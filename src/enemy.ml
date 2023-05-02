open Yojson.Basic.Util

exception UnknownEnemy of string

type t = {
  name : string;
  health : int;
  damage : int;
  gold : int;
  tier : int;
}

let enemy_of_json j =
  {
    name = j |> member "name" |> to_string;
    health = j |> member "health" |> to_int;
    damage = j |> member "damage" |> to_int;
    gold = j |> member "gold" |> to_int;
    tier = j |> member "tier" |> to_int;
  }

let enemy_database =
  let data_dir_prefix = "data" ^ Filename.dir_sep in
  let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json") in
  enemy_json |> member "enemies" |> to_list |> List.map enemy_of_json

let enemy_tier (tier : int) =
  List.filter (fun e -> e.tier = tier) enemy_database

(* let init_enemy (tier : int) = let found = List.find (fun e -> e.name =
   enemy_name) enemy_database in match found with | exception Not_found -> raise
   (UnknownEnemy enemy_name) | e -> e*)
let init_enemy (tier : int) =
  let pos_enemies = enemy_tier tier in
  let n = Random.int (List.length pos_enemies) in
  List.nth pos_enemies n

let change_health t damage = { t with health = t.health - damage }
let enemy_health t = t.health
let enemy_gold t = t.gold
let enemy_damage t = t.damage
