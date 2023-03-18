open Game
open Yojson
open OUnit2
open Card
open Player
open Command
open Enemy
open State

let data_dir_prefix = "data" ^ Filename.dir_sep
let card_json = Yojson.Basic.from_file (data_dir_prefix ^ "card.json")
let enemy_json = Yojson.Basic.from_file (data_dir_prefix ^ "enemy.json")

(** (TODO) create a starting_deck for the player*)
let card_tests = []
let command_tests = []
let enemy_tests = []
let player_tests = []
let state_tests = []



let suite =
  "test suite for Final Project"
  >::: List.flatten [ card_tests; command_tests; enemy_tests; player_tests; state_tests ]

let _ = run_test_tt_main suite