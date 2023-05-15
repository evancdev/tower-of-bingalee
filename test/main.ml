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

let enemy_tier_test name tier expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_names (enemy_tier tier))

let enemy_health_test name enemy expected_output : test =
  name >:: fun _ -> assert_equal expected_output (enemy_health enemy)

let card_tests = []

let command_tests =
  [
    parse_test "extra spaces with play" "play clash "
      (Play [ "omega"; "attack" ]);
    parse_test "testing if checkhand works" "checkhand" CheckHand;
    parse_test "go command with valid input" "go 1 " (Go [ "1" ]);
    parse_test "endturn\n   command" "end" EndTurn;
    parse_test "quit command" "quit" Quit;
    parse_test "tryagain command" "try again" TryAgain;
    parse_test "buy command" "buy cleave\n   " (Buy [ "cleave" ]);
    parse_test "sell command" "sell cleave " (Sell [ "cleave" ]);
    parse_test "heal command" "heal" Heal;
    parse_test "recharge\n   command" "recharge" Recharge;
    exn_parse_test "go command with invalid input" "go omega attack " Malformed;
    exn_parse_test
      "malfromed exception when end\n   has a non-empty string after end"
      "end hkeje" Malformed;
    exn_parse_test
      "malfromed exception when string has a empty string after play" "play "
      Malformed;
    exn_parse_test "malfromed exception when first word is not play or\n   end"
      "omega attack" Malformed;
    exn_parse_test "empty exception when string\n   contains empty spaces" " "
      Empty;
    exn_parse_test "empty exception when\n\n   string is the empty string" ""
      Empty;
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

let player_tests = []
let state_tests = []

let suite =
  "test suite for Final Project"
  >::: List.flatten
         [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

let _ = run_test_tt_main suite
