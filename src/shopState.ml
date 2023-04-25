open Card
open Player
open Random

exception InvalidPurchase of string
exception CannotSell of string
exception CardRemoval of string

type t = {
  cards : string list;
  gold : int;
  player : Player.t;
  card_removal : int;
  removal_cost : int;
}

let removal_price = ref 3
let floor = 1
let tier1 = []
let tier2 = []
let tier3 = []

let rec get_random_cards (cards : string list) (size : int) =
  match size with
  | 0 -> []
  | _ ->
      let element = Random.int (List.length cards) |> List.nth cards in
      element :: get_random_cards cards (size - 1)

let generate_shop_cards =
  let size = Random.int 2 + 5 in
  function
  | 1 -> get_random_cards tier1 size
  | 2 -> get_random_cards tier2 size
  | 3 -> get_random_cards tier3 size
  | _ -> []

let create_shop (floor : int) (depth : int) (player : Player.t) =
  {
    cards = generate_shop_cards floor;
    gold = (floor * 7) + (depth * 2);
    player;
    card_removal = 1;
    removal_cost = !removal_price;
  }

let get_cards (shop : t) = shop.cards
let get_gold (shop : t) = shop.gold
let get_card_removals (shop : t) = shop.card_removal
let get_removal_cost (shop : t) = shop.removal_cost

let sell_card (player : Player.t) (shop : t) (card : string) =
  match List.mem card (player_cards player) with
  | false ->
      raise (CannotSell "ARGH! You cannot sell a card that you don't have!")
  | true ->
      {
        shop with
        cards = card :: shop.cards;
        gold = shop.gold - 1;
        player = Player.remove_card player card;
      }

(* duplicate code from player.ml, maybe find a way to remove duplicate code?*)
let shop_remove_card (shop : t) (card_name : string) : t =
  let rec removing (count : int) =
    match shop.cards with
    | [] -> []
    | h :: t ->
        if h = card_name then
          List.filteri (fun i _ -> i < count) shop.cards
          @ List.filteri (fun i _ -> i > count) shop.cards
        else removing (count + 1)
  in
  { shop with cards = removing 0 }

let buy_card (player : Player.t) (shop : t) (card : string) =
  match List.mem card shop.cards with
  | false ->
      raise (InvalidPurchase "The shop isn't selling that card. Too bad!")
  | true ->
      {
        (shop_remove_card shop card) with
        gold = shop.gold + 1;
        player = change_gold_player (add_card player card) (-1);
      }

let buy_card_removal (player : Player.t) (shop : t) (card : string) =
  match shop.card_removal with
  | 1 ->
      removal_price := !removal_price + 2;
      {
        (shop_remove_card shop card) with
        player = change_gold_player (remove_card player card) (- !removal_price);
        removal_cost = !removal_price;
      }
  | _ -> raise (CardRemoval "The shop is out of card removals")

let get_player_state (shop : t) = shop.player
