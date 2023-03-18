type card_name = string list

type command =
  | Play of card_name
  | End

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
      else if h = "end" && t = [] then End
      else raise Malformed

let parse str =
  if str = "" then raise Empty
  else split_on_space (String.split_on_char ' ' str) [] |> object_list
