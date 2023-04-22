open Player
open Enemy
open Card
open Printf

exception CardNotInHand of string

type t = {
  player : Player.t;
  enemy : Enemy.t;
}
(** The abstract type of values representing the game state. *)

let init_state (player_name : string) (enemy_name : string) =
  { player = create_player player_name; enemy = init_enemy enemy_name }

(**plays the card*)
let play_card (card_database : Card.t) (card_name : string) (state : t) =
  if List.mem card_name (player_hand state.player) then
    let new_enemy_state = card_name |> get_dmg |> change_health state.enemy in
    (* print_endline (string_of_int (enemy_health new_enemy_state)); *)
    { state with enemy = new_enemy_state }
  else raise (CardNotInHand card_name)

(**returns player hand*)
let checkhand (state : t) = player_hand state.player

type status =
  | Alive
  | PlayerDead
  | EnemyDead

let game_state (state : t) =
  if player_health state.player <= 0 then PlayerDead
  else if enemy_health state.enemy <= 0 then EnemyDead
  else Alive

let enemy_attacks (state : t) =
  { state with player = change_health_player state.player 5 }

let get_healths (state : t) =
  (player_health state.player, enemy_health state.enemy)
