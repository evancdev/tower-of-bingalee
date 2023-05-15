open Game

exception Restart
exception End

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

let check_hand s =
  let active, hand = BattleState.get_card_state s in
  ANSITerminal.print_string [ ANSITerminal.Bold; ANSITerminal.green ] "Active: ";
  print_endline (UsefulFunctions.join_slist active ", ");
  ANSITerminal.print_string [ ANSITerminal.Bold; ANSITerminal.magenta ] "Hand: ";
  print_endline (UsefulFunctions.join_slist hand ", ")

let print_battlefield (s : BattleState.t) =
  print_endline "\n\n";
  print_string ("  𖨆\t\t" ^ Enemy.enemy_face (BattleState.enemy_battle s));
  print_endline "";
  let ph, eh = BattleState.get_health_strings s in
  print_endline (ph ^ "\t\t" ^ eh);
  print_endline ("Energy: ⚡" ^ string_of_int (BattleState.get_cur_energy s));
  print_endline "";
  check_hand s

let read_input () =
  ANSITerminal.print_string [ ANSITerminal.green; ANSITerminal.Bold ] "> ";
  let open Command in
  () |> read_line |> parse

let play_card c s =
  let open BattleState in
  match activate_card s c with
  | exception CardNotInHand msg ->
      ANSITerminal.print_string [ ANSITerminal.red; ANSITerminal.Bold ] msg;
      s
  | exception NotEnoughEnergy ->
      ANSITerminal.print_string
        [ ANSITerminal.Bold; ANSITerminal.red ]
        "Not enough energy.\n";
      s
  | s' -> s'

let check_hand_from_player p =
  print_endline
    ("Cards:\n    - "
    ^ UsefulFunctions.join_slist (Player.player_cards p) "\n    - ")

let end_turn s =
  let open BattleState in
  let s' = s |> eval_active |> draw in
  if game_state s' = EnemyDead then (
    print_endline "You won the battle!";
    (true, false, gold_on_kill s'))
  else
    let s'' = enemy_attacks s' in
    print_endline "You played your turn.";
    enemy_hit s'';
    if game_state s'' = PlayerDead then (false, true, s'')
    else (false, false, reset_turn s'')

let info c =
  let open Card in
  match description c with
  | s ->
      ANSITerminal.print_string
        [ ANSITerminal.magenta; ANSITerminal.Underlined ]
        (c ^ "\n");
      print_string s
  | exception UnknownCard s -> print_endline s

let battle (p : Player.t) (flr : int) =
  let rec battle_loop s =
    print_battlefield s;
    match read_input () with
    | Play c ->
        let s' = play_card c s in
        battle_loop s'
    | EndTurn -> (
        match end_turn s with
        | true, _, s' -> s'
        | _, true, s' -> raise Restart
        | _, _, s' -> battle_loop s')
    | Quit -> raise End
    | Info c ->
        info c;
        battle_loop s
    | _ -> battle_loop s
    | exception Command.Malformed -> battle_loop s
    | exception Command.Empty -> battle_loop s
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
    match read_input () with
    | Go i -> i
    | Quit -> raise End
    | _ -> door_loop ()
    | exception Command.Malformed -> door_loop ()
    | exception Command.Empty -> door_loop ()
  in
  let door_choices = Encounter.generate_encounters () in
  display_doors door_choices;
  List.nth door_choices (door_loop () - 1)

let print_shop s =
  ANSITerminal.print_string
    [ ANSITerminal.magenta; ANSITerminal.Bold ]
    "\n\
     You're in a small, decrepid shop. The merchant\n\
     behind the counter peers at you warily.\n";
  ANSITerminal.print_string [ ANSITerminal.green ]
    "\tYou can't help but notice the glitter in his\n\
     \teyes as he glances at your coin purse...\n\
     \tOr was it your imagination?\n\n";
  ANSITerminal.print_string
    [ ANSITerminal.magenta; ANSITerminal.Underlined ]
    "Cards For Sale\n";
  print_endline
    ("   - "
    ^ UsefulFunctions.join_slist (ShopState.get_cards s) "\n   - "
    ^ "\n");
  ANSITerminal.print_string
    [ ANSITerminal.magenta; ANSITerminal.Underlined ]
    "Card Removal Cost:";
  print_endline (" " ^ string_of_int (ShopState.get_removal_cost s) ^ "\n\n")

let shop (p : Player.t) flr dep =
  let open ShopState in
  let rec shop_loop s =
    print_shop s;
    match read_input () with
    | Buy c -> (
        match buy_card s c with
        | x -> shop_loop x
        | exception InvalidPurchase m ->
            print_endline m;
            shop_loop s)
    | Remove c -> (
        match buy_card_removal s c with
        | x -> shop_loop x
        | exception CardRemoval m ->
            print_endline m;
            shop_loop s)
    | Leave -> get_player_state s
    | CheckHand ->
        check_hand_from_player (get_player_state s);
        shop_loop s
    | Quit -> raise End
    | _ -> shop_loop s
    | exception Command.Malformed -> shop_loop s
    | exception Command.Empty -> shop_loop s
  in
  shop_loop (create_shop flr dep p)

let print_camp c =
  let open CampState in
  print_endline "\n";
  ANSITerminal.print_string [ ANSITerminal.cyan ]
    "A cool breeze blows through your hair... It's peaceful here.";
  print_endline "\n";
  if exists_energy c then print_endline "\tA Gatorade bottle lies at your feet."
  else print_endline "\tAn empty Gatorade bottle lies at your feet.";
  if exists_hp c then
    print_endline "\tNext to the bottle, you see a cozy looking blanket."
  else
    print_endline
      "\tNext to the bottle, you see a cozy blanket, but you're not tired.";
  print_endline ""

let camp (p : Player.t) =
  let open CampState in
  let rec camp_loop c =
    print_camp c;
    match read_input () with
    | Heal ->
        (match c |> sleep_health with
        | c' ->
            ANSITerminal.print_string [ ANSITerminal.green ]
              "You lay down to take a nap. Health increased!";
            c'
        | exception CampState.InvalidChoice s ->
            ANSITerminal.print_string [ ANSITerminal.red ] s;
            camp_loop c)
        |> camp_loop
    | Recharge ->
        (match c |> gatorade_energy with
        | c' ->
            ANSITerminal.print_string [ ANSITerminal.yellow ]
              "You chug the bottle of gatorade. Electrolytes course through \
               your body! Max energy increased!";
            c'
        | exception CampState.InvalidChoice s ->
            ANSITerminal.print_string [ ANSITerminal.red ] s;
            camp_loop c)
        |> camp_loop
    | Leave ->
        ANSITerminal.print_string [ ANSITerminal.red ]
          "You leave the camp and all it's peacefullness. \n\
           You miss the feeling of ease already...\n\
           but the grind must go on...\n\n";
        c
    | Quit -> raise End
    | _ -> camp_loop c
    | exception Command.Malformed -> camp_loop c
    | exception Command.Empty -> camp_loop c
  in
  p |> create_camp |> camp_loop |> get_player_state

let encounter p flr dep =
  match door () with
  | "Battle" -> battle p flr
  | "Shop" -> shop p flr dep
  | "Camp" -> camp p
  | "Chance" -> p (*FIX AFTER GETTING MLI*)
  | _ -> failwith "not possible"

let rec restart () =
  match read_input () with
  | TryAgain -> true
  | Quit -> false
  | _ -> restart ()
  | exception Command.Malformed -> restart ()
  | exception Command.Empty -> restart ()

let rec floor p flr =
  match
    ANSITerminal.print_string [ ANSITerminal.green ]
      "\n\
      \    You step into a new realm... eager to explore.\n\
      \    It's not long before you're ambushed!";
    let p1 = battle p flr in
    let p2 = encounter p1 flr 2 in
    let p3 = encounter p2 flr 3 in
    let p4 = encounter p3 flr 4 in
    ANSITerminal.print_string
      [ ANSITerminal.red; ANSITerminal.Bold ]
      "\nA boss approaches...";
    let p5 = battle p4 (flr + 3) in
    p5
  with
  | exception Restart ->
      ANSITerminal.print_string
        [ ANSITerminal.Bold; ANSITerminal.red ]
        "You died.\n\n";
      print_endline
        {|type "again" to try once more or "quit" to end the adventure|};
      if restart () then floor p flr else raise End
  | exception End -> raise End
  | p' -> p'

let adventure_begin () =
  match
    (*** START ***)
    let p0 = Player.create_player () in
    let p1 = floor p0 1 in
    let p2 = floor p1 2 in
    ignore (floor p2 3);
    print_endline "You win!"
  with
  | exception End -> print_endline "Goodbye...\n"
  | _ -> ()

(* let print_enemy state (color:string) face s = ANSITerminal.print_string
   [ANSITerminal.color; ANSITerminal.Bold] face; ANSITerminal.print_string [
   ANSITerminal.Bold ] ("\n\n" ^ s ^ "\n"); *)

let main () =
  print_endline "";
  ANSITerminal.print_string
    [ ANSITerminal.Bold; ANSITerminal.cyan ]
    "Welcome to the World of Bingalee\n";
  adventure_begin ()

let () = ignore (shop (Player.create_player ()) 1 1)
