type t
(**representation of shop*)

exception InvalidPurchase of string
exception CannotSell of string

val create_shop : int -> int -> Player.t -> t
(**creates a shop based on the current floor and depth*)

val sell_card : Player.t -> t -> string -> t
(**the player sells a card to the shop*)

val buy_card : Player.t -> t -> string -> t
(**the player buys a card from the shop*)

val get_player_state : t -> Player.t
(**returns the player state*)
