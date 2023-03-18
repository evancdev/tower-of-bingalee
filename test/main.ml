<<<<<<< HEAD
open Game
open Yojson.Basic.Util
open OUnit2
open Card
open Command
open Player
open Enemy
open State
open OUnit2

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json")

(** (TODO) create a starting_deck for the player*)
let player = create_player "Player1"
let card_tests = []
let command_tests = []
let enemy_tests = []
let player_tests = []
let state_tests = []



let suite =
  "test suite for Final Project"
  >::: List.flatten [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

=======
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
let command_tests = [parse_test "extra spaces with play" "play  omega attack  "
(Play [ "omega"; "attack" ]);]
let enemy_tests = []
let player_tests = []
let state_tests = []



let suite =
  "test suite for Final Project"
  >::: List.flatten [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

>>>>>>> 9997fac689397c3df57c8c8d64850772772e980e
let _ = run_test_tt_main suite