open Yojson.Basic.Util

type enemy = {
  name : string;
  health : int;
  block : int;
}

type t = { enemies : enemy list }

let enemy_of_json j =
  {
    name = j |> member "name" |> to_string;
    health = j |> member "health" |> to_int;
    block = j |> member "block" |> to_int;
  }

let all_enemies_of_json j =
  { enemies = j |> member "enemies" |> to_list |> List.map enemy_of_json }

let enemy_health t = 1
let enemy_block t = 1
