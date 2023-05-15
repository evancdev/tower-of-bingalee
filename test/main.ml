(***** TEST PLAN: The automated test suite using OUnit was helpful in testing
  single interactions between states. Since our game is fundamentally built off
  the exchange of various states across different "environments," such as a
  shop, camp, battle, etc, we used OUnit to verify that states were correctly
  updating with the right information as well as being passed along correctly to
  other states. Another example where OUnit was helpful was in verifying that
  string inputs to a command parser still resulted in the right command
  Variants, despite having extra white space and whatnot. OUnit was also helpful
  for verifying slightly more complex operations, such as single turns in a
  battle. The synergy feature we provide between cards is not very
  straightforward in damage calculation, so OUnit allowed us to have a
  controlled environment to observe the single outcome. What we had to test
  manually via [make play] was the actual adventure from start to finish, as
  well as progressing between environments like shops to battles, etc. This
  testing took place manually since the actual engine runs as the bridge between
  the operations we test with OUnit.

  Specific modules that were tested by OUnit include: BattleState, CampState,
  Card, Command, Encounter, Enemy, Player, ShopState, and UsefulFunctions. We
  used a combination of black box and glass box testing. For example, the
  testing of the synergy between two cards involved a few black box unit tests,
  as all we know is the outcome to an enemy's health and not the gory details
  about how synergy is identified in the code. For many other tests, we used
  glass box testing to narrow in on small operations, such as parsing Commands,
  which we know strips away extraneous white space. We also test our enemy tier
  system, a system that is completely hidden to the game player but is
  nevertheless important to test for our implementation purposes. Overall, our
  combination of blackbox and glassbox testing was effective in elucidating
  issues and gaining confidence in our system.

  Once again, our system essentially functions based on passing around states.
  For example, the player state is a recurring source of information that is
  continuously updated/overwritten over the course of the game. The player state
  is passed into other states, such as the shop and battle states, and its
  information is extracted and used for calculations regarding those
  environments. As this is the core feature of our game, the way we test our
  modules—and our state modules in particular by verifying the correct
  transferral of information—should naturally give us confidence in the entire
  system working. Because we can verify all the small operations work in fine
  detail, we are confident the more complex operations that go into the final
  game are also correct on this foundation.*)

open Game
open Yojson.Basic.Util
open OUnit2
open Card
open Command
open Player
open Enemy
open BattleState
open CampState
open OUnit2

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json")

(* command test functions *)
let parse_test (name : string) str (expected_output : command) : test =
  name >:: fun _ -> assert_equal expected_output (parse str)

let exn_parse_test (name : string) str expected_output : test =
  name >:: fun _ -> assert_raises expected_output (fun _ -> parse str)

(* player test functions *)
let player_health_test (name : string) (player : Player.t) expected_output :
    test =
  name >:: fun _ -> assert_equal expected_output (player_health player)

let player_cur_health_test (name : string) (player : Player.t) expected_output :
    test =
  name >:: fun _ -> assert_equal expected_output (player_cur_health player)

let player_max_energy_test (name : string) (player : Player.t) expected_output :
    test =
  name >:: fun _ -> assert_equal expected_output (player_max_energy player)

let player_cards_test (name : string) (player : Player.t) expected_output : test
    =
  name >:: fun _ -> assert_equal expected_output (player_cards player)

let player_stage_test (name : string) (player : Player.t) expected_output : test
    =
  name >:: fun _ -> assert_equal expected_output (player_stage player)

(* card test functions *)
let add_card_test (name : string) (player : Player.t) (card : string)
    expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (add_card player card |> player_cards)

let p_remove_card_test (name : string) (player : Player.t) (card : string)
    expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (p_remove_card player card |> player_cards)

let change_player_mhp_test (name : string) (player : Player.t) (amount : int)
    expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (change_player_mhp player amount |> player_health)

let change_gold_player_test (name : string) (player : Player.t) (amount : int)
    expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (change_gold_player player amount |> player_gold)

let change_player_menergy_test (name : string) (player : Player.t)
    (amount : int) expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output
    (change_player_menergy player amount |> player_max_energy)

(* enemy test functions *)

let enemy_tier_test name tier expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_names (enemy_tier tier))

let enemy_health_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_health enemy)

let synergy_test (name : string) (enemy : string) (cards : string list)
    expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output
    (Enemy.enemy_health
       (BattleState.enemy_battle
          (eval_active (for_player_attack_test (Enemy.enemy_from enemy) cards))))
    ~printer:string_of_int

let enemy_gold_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_gold enemy)

let enemy_damage_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_damage enemy)

let enemy_name_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_name enemy)

let enemy_face_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_face enemy)

let enemy_max_health_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_max_health enemy)

let change_health_enemy_test name enemy damage expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (change_health_enemy enemy damage |> enemy_health)

(* camp test functions *)
let exists_energy_test name camp expected_output : test =
  name >:: fun _ -> assert_equal expected_output (exists_energy camp)

let exists_hp_test name camp expected_output : test =
  name >:: fun _ -> assert_equal expected_output (exists_hp camp)

let sleep_health_bool_test name camp expected_output : test =
  name >:: fun _ -> assert_equal expected_output (sleep_health camp |> exists_hp)

let sleep_health_int_test name camp expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output
    (sleep_health camp |> get_player_state |> player_cur_health)

let gatorade_energy_bool_test name camp expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (gatorade_energy camp |> exists_energy)

let gatorade_energy_int_test name camp expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output
    (gatorade_energy camp |> get_player_state |> player_max_energy)

let stats_camp_test name camp expected_output : test =
  name >:: fun _ ->
  assert_equal expected_output (stats camp) ~printer:String.escaped

let card_tests = []

let command_tests =
  [
    parse_test "extra spaces with play" "play  clash " (Play "clash");
    parse_test "testing if checkhand works" "checkhand" CheckHand;
    parse_test "go command with valid input" "go 1 " (Go 1);
    parse_test "endturn\n   command" "end" EndTurn;
    parse_test "quit command" "quit" Quit;
    parse_test "help command" "help" Help;
    parse_test "tryagain command" "again" TryAgain;
    parse_test "buy command" "buy cleave   " (Buy "cleave");
    parse_test "remove command" "remove cleave " (Remove "cleave");
    parse_test "heal command" "heal" Heal;
    parse_test "recharge\n   command" "recharge" Recharge;
    parse_test "leave command" "leave" Leave;
    parse_test "info command" "info strike" (Info "strike");
    exn_parse_test "go command with invalid input" "go omega attack " Malformed;
    exn_parse_test
      "malfromed exception when end\n   has a non-empty string after end"
      "end hkeje" Malformed;
    exn_parse_test
      "malfromed exception when string has a empty string after play" "play "
      Malformed;
    exn_parse_test "malfromed exception when first word is not play or end"
      "omega attack" Malformed;
    exn_parse_test "empty exception when string\n   contains empty spaces" " "
      Empty;
    exn_parse_test "empty exception when string is the empty string" "" Empty;
  ]

let player_tests =
  let player = create_player () in
  [
    player_health_test "Init Player Max Health" player 50;
    player_cur_health_test "Init Player Curr Health" player 50;
    player_max_energy_test "Init Player Max Energy" player 3;
    player_cards_test "Init Player Cards" player
      [
        "block";
        "block";
        "block";
        "block";
        "strike";
        "strike";
        "strike";
        "strike";
        "strike";
        "cleave";
      ];
    player_stage_test "Init Player Stage" player (1, 0);
    add_card_test "Add parry to Player Cards" player "parry"
      (player_cards player @ [ "parry" ]);
    ( "Add Nonexistent Card to Player Cards" >:: fun _ ->
      assert_raises (UnknownCard "Not a valid card.") (fun _ ->
          add_card player "NONEXISTENT") );
    p_remove_card_test "Remove parry from Player Cards"
      (add_card player "parry") "parry" (player_cards player);
    p_remove_card_test "Removing an nonexistent card does nothing" player
      "NONEXISTENT" (player_cards player);
    change_player_mhp_test "Increase Max HP by 5" player 5 55;
    change_player_mhp_test "Decrease Max HP by 5" player (-5) 45;
    change_gold_player_test "Give Player 10 Gold" player 10 20;
    change_gold_player_test "Remove Player 10 Gold" player (-10) 0;
    change_player_menergy_test "Increase Max Energy by 1" player 1 4;
  ]

let enemy_tests =
  let enemy = init_enemy 2 in
  [
    enemy_health_test "health of generated enemy(robot)" enemy 25;
    enemy_gold_test "gold of generated enemy(robot)" enemy 2;
    enemy_damage_test "damage of generated enemy(robot)" enemy 5;
    enemy_name_test "name of generated enemy is robot " enemy "robot";
    enemy_face_test "face of generated enemy is d[o_0]b " enemy "d[o_0]b";
    enemy_max_health_test "maximum health of generated enemy(robot)" enemy 25;
    change_health_enemy_test "decreasing health to 5" enemy 20 5;
    change_health_enemy_test "increasing health to 30" enemy (-5) 30;
    enemy_tier_test "tier 1 enemies" 1 [ "slime"; "bird" ];
    enemy_tier_test "tier 2 enemies" 2 [ "robot" ];
    enemy_tier_test "tier 3 enemies" 3 [ "zombie"; "ghost" ];
    enemy_tier_test "tier 4 enemies" 4 [ "vampire" ];
    enemy_tier_test "tier 5 enemies" 5 [ "mary" ];
    enemy_tier_test "tier 6 enemies" 6 [ "clown" ];
  ]

let camp_tests =
  let player = create_player () in
  let camp = create_camp player in
  [
    exists_energy_test "health available after arrival to camp" camp true;
    exists_energy_test "energy available after arrival to camp" camp true;
    sleep_health_bool_test "health unavailable after heal" camp false;
    gatorade_energy_bool_test "gatorade unavailable after recharge" camp false;
    sleep_health_int_test "health stays at 50 after heal" camp 50;
    gatorade_energy_int_test "gatorade increases max energy to 4 after recharge"
      camp 4;
    stats_camp_test "stats when you arrive at camp" camp
      "Health: ♡ 50/50\nEnergy: 3";
  ]

let state_tests = []
let shop_tests = []

let synergy_tests =
  [
    synergy_test "clothesline + german suplex" "bird"
      [ "clothesline"; "german suplex" ]
      8;
    synergy_test "clothesline + german suplex" "bird"
      [ "german suplex"; "clothesline" ]
      8;
  ]

let suite =
  "test suite for Final Project"
  >::: List.flatten [ command_tests; player_tests; enemy_tests; camp_tests ]

let _ = run_test_tt_main suite
