open Random
open UsefulFunctions

type t =
  | Battle
  | Shop
  | Camp
  | Chance

let to_string = function
  | Battle -> "Battle"
  | Shop -> "Shop"
  | Camp -> "Question"
  | Chance -> "Chance"

let get_random =
  [ Battle; Shop; Camp; Chance ]
  |> List.length |> ( - ) 1 |> Random.int |> ( + ) 1
  |> List.nth [ Battle; Shop; Camp; Chance ]

let generate_encounters =
  let creating_list = get_random :: get_random :: [ Battle ] in
  List.map to_string creating_list |> shuffle
