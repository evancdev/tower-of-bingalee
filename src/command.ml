type card_name = string list
type door = string list

type command =
  | Play of card_name
  | CheckHand
  | Go of door
  | EndTurn
  | Quit
  | TryAgain
  | Buy of card_name
  | Sell of card_name
  | Heal
  | Recharge

exception Empty
(** Raised when an empty command is parsed. *)

exception Malformed
(** Raised when a malformed command is parsed. *)

let rec split_on_space (s : string list) acc =
  match s with
  | [] -> List.rev acc
  | h :: t ->
      if h = "" then split_on_space t acc else split_on_space t (h :: acc)

let object_list (lst : string list) =
  match lst with
  | [] -> raise Empty
  | h :: t ->
      if h = "play" && t != [] then Play t
      else if h = "checkhand" && t = [] then CheckHand
      else if h = "go" && (t = [ "1" ] || t = [ "2" ] || t = [ "3" ]) then Go t
      else if h = "end" && t = [] then EndTurn
      else if h = "quit" && t = [] then Quit
      else if h = "again" && t = [] then TryAgain
      else if h = "buy" && t != [] then Buy t
      else if h = "sell" && t != [] then Sell t
      else if h = "heal" && t = [] then Heal
      else if h = "recharge" && t = [] then Recharge
      else raise Malformed

let parse str =
  if str = "" then raise Empty
  else split_on_space (String.split_on_char ' ' str) [] |> object_list
