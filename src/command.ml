type card_name = string

type command =
  | Play of card_name
  | End

exception Empty
(** Raised when an empty command is parsed. *)

exception Malformed
(** Raised when a malformed command is parsed. *)

let parse = raise (Failure "unimplemented")
