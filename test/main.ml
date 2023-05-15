open Game
open Yojson.Basic.Util
open OUnit2
open Card
open Command
open Player
open Enemy
open BattleState
open OUnit2

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json")

let parse_test (name : string) str (expected_output : command) : test =
  name >:: fun _ -> assert_equal expected_output (parse str)

let exn_parse_test (name : string) str expected_output : test =
  name >:: fun _ -> assert_raises expected_output (fun _ -> parse str)

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

let enemy_tier_test name tier expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_names (enemy_tier tier))

let enemy_health_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_health enemy)

let card_tests = []

let command_tests =
  [
    parse_test "extra spaces with play" "play  clash " (Play "clash");
    parse_test "testing if checkhand works" "checkhand" CheckHand;
    parse_test "go command with valid input" "go 1 " (Go 1);
    parse_test "endturn\n   command" "end" EndTurn;
    parse_test "quit command" "quit" Quit;
    parse_test "tryagain command" "again" TryAgain;
    parse_test "buy command" "buy cleave   " (Buy "cleave");
    parse_test "remove command" "remove cleave " (Remove "cleave");
    parse_test "heal command" "heal" Heal;
    parse_test "recharge\n   command" "recharge" Recharge;
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
        "clash";
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
    change_gold_player_test "Give Player 10 Gold" player 10 10;
    change_gold_player_test "Remove Player 10 Gold" player (-10) (-10);
    change_player_menergy_test "Increase Max Energy by 1" player 1 4;
  ]

let enemy_tests =
  [
    enemy_tier_test "tier 1 enemies" 1 [ "slime"; "bird" ];
    enemy_tier_test "tier 2 enemies" 2 [ "robot" ];
    enemy_tier_test "tier 3 enemies" 3 [ "zombie"; "ghost" ];
    enemy_tier_test "tier 4 enemies" 4 [ "vampire" ];
    enemy_tier_test "tier 5 enemies" 5 [ "mary" ];
    enemy_tier_test "tier 6 enemies" 6 [ "clown" ];
  ]

let state_tests = []
let shop_tests = []
let suite = "test suite for Final Project" >::: List.flatten [ player_tests ]
let _ = run_test_tt_main suite
