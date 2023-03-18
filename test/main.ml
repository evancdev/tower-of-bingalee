open Game
open Yojson.Basic.Util
open OUnit2
open Card
open Command
open Enemy
open State
open OUnit2

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json")

let parse_test (name : string) str (expected_output : command) : test =
  name >:: fun _ -> assert_equal expected_output (parse str)

(** (TODO) create a starting_deck for the player*)
let card_tests = []

let command_tests =
  [
    parse_test "extra spaces with play" "play  omega attack  "
      (Play [ "omega"; "attack" ]);
    ( "malfromed exception when end has a non-empty string after end"
    >:: fun _ -> assert_raises Malformed (fun _ -> parse "end hkeje") );
    ( "malfromed exception when string has a empty string after play"
    >:: fun _ -> assert_raises Malformed (fun _ -> parse "play ") );
    ( "malfromed exception when first word is not play or end" >:: fun _ ->
      assert_raises Malformed (fun _ -> parse "omega attack") );
    ( "empty exception when string contains empty spaces" >:: fun _ ->
      assert_raises Empty (fun _ -> parse "    ") );
    ( "empty exception when string is the empty string" >:: fun _ ->
      assert_raises Empty (fun _ -> parse "") );
  ]

let enemy_tests = []
let player_tests = []
let state_tests = []

let suite =
  "test suite for Final Project"
  >::: List.flatten
         [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

let _ = run_test_tt_main suite
