open Game

let play_card c s = raise (Failure "unimplemented")
let check_hand s = raise (Failure "unimplemented")
let end_turn s = raise (Failure "unimplemented")


let rec battle_loop s = 
  let open Command in
  match () |> read_line |> parse with 
  | Play c -> play_card c s
  | CheckHand -> check_hand s
  | EndTurn -> end_turn s
  | _ -> battle_loop s
    (**TODO: catch more to print better error messages, add validation*)


let battle (p : Player.t) (flr : int) =
  flr |> BattleState.init_battle p  |> battle_loop
  
let shop 

let adventure_begin () = 
  let p0 = Player.create_player "Leonardo DiCaprio" in
  let route = "Battle" :: Encounter.generate_encounters in
  let rec do_encounter (r : string list) (flr : int) (p : Player.t) = 
    match r with 
    | [] -> p
    | h :: t -> (match h with 
                | "Battle" -> flr |> battle p |> do_encounter t (flr - 1) )
                | "Shop" -> 
(*TODO: Boss encounter*)
  

let main () = 
  print_endline "Starting game...";
  adventure_begin ()

let () = main ()