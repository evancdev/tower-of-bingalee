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

let player = create_player "Player1"
let card_tests = []

let command_tests =
  [
    parse_test "extra spaces with play" "play  omega attack  "
      (Play [ "omega"; "attack" ]);
    parse_test "testing if quit works" "quit" Quit;
    parse_test "testing if endturn works" "end" EndTurn;
    parse_test "testing if checkhand works" "checkhand" CheckHand;
    parse_test "testing if go works" "go 1" (Go [ "1" ]);
    exn_parse_test
      "malfromed exception when end has a non-empty string after end"
      "end hkeje" Malformed;
    exn_parse_test
      "malfromed exception when string has a empty string after play" "play "
      Malformed;
    exn_parse_test "malfromed exception when first word is not play or end"
      "omega attack" Malformed;
    exn_parse_test "empty exception when string contains empty spaces" "   "
      Empty;
    exn_parse_test "empty exception when\n    string is the empty string" ""
      Empty;
  ]

let enemy_tests = []
let player_tests = []
let state_tests = []

let suite =
  "test suite for Final Project"
  >::: List.flatten
         [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

let _ = run_test_tt_main suite
