open Game

let play_card c s = raise (Failure "unimplemented")
let check_hand s = raise (Failure "unimplemented")
let end_turn s = raise (Failure "unimplemented")

(**TODO: catch more to print better error messages, add validation*)
let rec battle_loop s =
  let open Command in
  match () |> read_line |> parse with
  | Play c -> play_card c s
  | CheckHand -> check_hand s
  | EndTurn -> end_turn s
  | _ -> battle_loop s

let battle (p : Player.t) (flr : int) =
  flr |> BattleState.init_battle p |> battle_loop

(* let shop *)

let rec adventure_begin () = let p0 = Player.create_player "Leonardo
   DiCaprio" in let route = "Battle" :: Encounter.generate_encounters in let rec
   do_encounter (r : string list) (flr : int) (p : Player.t) = match r with | []
   -> p | h :: t -> (match h with | "Battle" -> flr |> battle p |> do_encounter
   t (flr - 1) )

   | "Shop" ->
(*TODO: Boss encounter*)

(* let print_enemy state (color:string) face s = ANSITerminal.print_string
   [ANSITerminal.color; ANSITerminal.Bold] face; ANSITerminal.print_string [
   ANSITerminal.Bold ] ("\n\n" ^ s ^ "\n"); *)

let enemy_hit (state : BattleState.t) =
  let enemy = BattleState.enemy_battle state in
  let face = Enemy.enemy_face enemy in
  match Enemy.enemy_name enemy with
  | "slime" ->
      ANSITerminal.print_string [ ANSITerminal.green; ANSITerminal.Bold ] face;
      ANSITerminal.print_string [ ANSITerminal.Bold ]
        "\n\n A SLIME BABY STARTS CRAWLING TOWARDS YOU...\n"
  | "bird" ->
    ANSITerminal.print_string [ ANSITerminal.blue; ANSITerminal.Bold ] face;
    ANSITerminal.print_string [ ANSITerminal.Bold ]
      "\n\n A VULTURE STARTS FLYING IN YOUR DIRECTION\n"
  | "vampire" ->
    ANSITerminal.print_string [ ANSITerminal.red; ANSITerminal.Bold ] face;
    ANSITerminal.print_string [ ANSITerminal.Bold ]
      "\n\n A VAMPIRE SEES THE BLOOD ON YOU AND SPEEDS TO YOU\n"
  | "robot" ->
    ANSITerminal.print_string [ ANSITerminal.blue; ANSITerminal.Bold ] face;
    ANSITerminal.print_string [ ANSITerminal.Bold ]
      "\n\n A ROBOT ROLLS TOWARDS YOU \n"
  | "mary" ->
    ANSITerminal.print_string [ ANSITerminal.white; ANSITerminal.Bold ] face;
    ANSITerminal.print_string [ ANSITerminal.Bold ]
      "\n\n BLOODY MARY HAS APPEARED AND STARTS TO HAUNT YOU \n"
  | "zombie" ->
  ANSITerminal.print_string [ ANSITerminal.yellow; ANSITerminal.Bold ] face;
  ANSITerminal.print_string [ ANSITerminal.Bold ]
    "\n\n ZOMBIE SLOWLY STARTS WALKING TO YOU\n"  
  | "ghost" ->
      ANSITerminal.print_string [ ANSITerminal.white; ANSITerminal.Bold ] face;
      ANSITerminal.print_string [ ANSITerminal.Bold ]
        "\n\n A GHOST FLOATS TOWARDS YOU\n"
  | "clown" ->
    ANSITerminal.print_string [ ANSITerminal.cyan; ANSITerminal.Bold ] face;
    ANSITerminal.print_string [ ANSITerminal.Bold ]
      "\n\n PENNYWISE WALKS TOWARDS YOU AND STARTS TURNING INTO YOUR BIGGEST FEAR \n"
  |_ -> failwith "Invalid enemy"

let main () =
  ANSITerminal.resize 130 130;
  print_endline "STARTING GAME...";
  adventure_begin ();
  ANSITerminal.erase Screen

let () = main ()
