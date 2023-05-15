type t
(**representation of shop*)

exception InvalidPurchase of string
exception CardRemoval of string
exception NotEnough of string

val create_shop : Player.t -> t
(**creates a shop based on the current floor and depth*)

val get_cards : t -> string list
(**gets the cards that the shop is selling*)

val get_card_removals : t -> int
(**gets the shop's card removal*)

val get_removal_cost : t -> int
(**gets the shop's card removal cost*)

val buy_card : t -> string -> t
(**the player buys a card from the shop. Raises InvalidPurchase when the player
   buys a card that the shop is not selling. Raises NotEnough when the player
   cannot afford the card*)

val buy_card_removal : t -> string -> t
(**the player buys a card removal from the shop. Raises CardRemoval when the
   player buys a card removal from a shop that does not have any.*)

val get_player_state : t -> Player.t
(**gets the player state*)
