open Game

let read_input =
  let open Command in
  () |> read_line |> parse

let play_card c s = BattleState.activate_card s c

let check_hand s =
  let active, hand = BattleState.get_card_state s in
  ignore active;
  ignore hand;
  print_endline "active";
  print_endline "hand"

let end_turn s = raise (Failure "unimplemented evaluation")

let battle (p : Player.t) (flr : int) =
  let rec battle_loop s =
    match read_input with
    | Play c -> play_card c s
    | CheckHand ->
        check_hand s;
        s
    | EndTurn -> end_turn s
    | _ -> battle_loop s
  in
  flr |> BattleState.init_battle p |> battle_loop
  |> BattleState.get_player_state

let display_doors doors =
  ignore
    (List.fold_left
       (fun i s ->
         print_endline ("Door " ^ string_of_int i ^ ": " ^ s);
         i + 1)
       1 doors)

let door () =
  let rec door_loop () =
    match read_input with
    | Go i -> i
    | _ -> door_loop ()
  in
  let door_choices = Encounter.generate_encounters in
  display_doors door_choices;
  List.nth door_choices (door_loop ())

let shop (p : Player.t) flr dep =
  let open ShopState in
  let rec shop_loop s =
    match read_input with
    | Buy c ->
        let s' = buy_card s c in
        shop_loop s'
    | Remove c ->
        let s' = buy_card_removal s c in
        shop_loop s'
    | Leave -> get_player_state s
    | _ -> shop_loop s
  in
  shop_loop (create_shop flr dep p)

let camp (p : Player.t) =
  let open CampState in
  let rec camp_loop c =
    match read_input with
    | Heal -> c |> sleep_health |> camp_loop
    | Recharge -> c |> gatorade_energy |> camp_loop
    | Leave -> c
    | _ -> camp_loop c
  in

  p |> create_camp |> camp_loop |> get_player_state

let encounter p flr dep =
  match door () with
  | "Battle" -> battle p flr
  | "Shop" -> shop p flr dep
  | "Camp" -> camp p
  | "Chance" -> p (*FIX AFTER GETTING MLI*)
  | _ -> failwith "not possible"

let floor p flr =
  let p1 = battle p flr in
  let p2 = encounter p1 flr 2 in
  let p3 = encounter p2 flr 3 in
  let p4 = encounter p3 flr 4 in
  let p5 = battle p4 4 in
  p5

let adventure_begin () =
  (*** START ***)
  let p0 = Player.create_player () in
  let p1 = floor p0 1 in
  let p2 = floor p1 2 in
  ignore (floor p2 3);
  print_endline "You win!"

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
        "\n\n\
        \ PENNYWISE WALKS TOWARDS YOU AND STARTS TURNING INTO YOUR BIGGEST FEAR \n"
  | _ -> failwith "Invalid enemy"

let main () =
  ANSITerminal.resize 130 130;
  print_endline "STARTING GAME...";
  adventure_begin ();
  ANSITerminal.erase Screen

let () = main ()
