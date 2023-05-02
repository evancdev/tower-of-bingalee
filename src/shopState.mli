type t
(**representation of shop*)

exception InvalidPurchase of string
exception CannotSell of string

val create_shop : int -> int -> Player.t -> t
(**creates a shop based on the current floor and depth*)

val get_cards : t -> string list
(**gets the cards that the shop is selling*)

val get_gold : t -> int
(**gets the shop's gold*)

val get_card_removals : t -> int
(**gets the shop's card removal*)

val get_removal_cost : t -> int
(**gets the shop's card removal cost*)

val sell_card : t -> string -> t
(**the player sells a card to the shop*)

val buy_card : t -> string -> t
(**the player buys a card from the shop*)

val buy_card_removal : t -> string -> t
(**the player buys a card removal from the shop*)

val get_player_state : t -> Player.t
(**gets the player state*)
