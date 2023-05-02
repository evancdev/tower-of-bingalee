open Game



let rec battle_loop s = 
  let open Command in
  match () |> read_line |> parse with 
  | Play c -> play_card s
  | CheckHand -> check_hand s
  | EndTurn -> end_turn s
  | _ -> battle_loop s
    (**TODO: catch more to print better error messages*)


let battle (p : Player.t) (e : string) =
  let state = BattleState.init_battle p e in
  
  

let adventure_begin () = 
  let p0 = Player.create_player "Leonardo DiCaprio" in
  let p1 = battle p in 

  
  

let main () = 
  print_endline "Starting game...";
  adventure_begin ()

let () = main ()