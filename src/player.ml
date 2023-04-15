type t = {
  name : string;
  health : int;
  energy : int;
  block : int;
  hand : string list;
  deck : string list;
  used_cards : string list; 
}

let create_player (name : string) =
  {
    name;
    health = 50;
    energy = 3;
    block = 0;
<<<<<<< HEAD
    hand = [];
    deck = ["OMEGA attack"; "OMEGA attack"; "OMEGA attack"; "OMEGA attack"];
    used_cards = [];
=======
    hand = [ "OMEGA attack"; "baby attack"; "zero attack"; "OMEGA attack" ];
    deck = [ "OMEGA attack"; "OMEGA attack"; "OMEGA attack"; "OMEGA attack" ];
>>>>>>> b8a38cf134a962095684a68966308a665236fa68
  }

(**[player_health] returns the player's current health*)
let player_health (p : t) : int = p.health

(**[player_block] returns the player's current block*)
let player_block (p : t) : int = p.block

(**[player_hand] returns the player's current hand*)
let player_hand (p : t) = p.hand

(**[player_energy] returns the player's current energy*)
let player_energy (p : t) : int = p.energy

(**[add_card] adds [card_name] to the player's deck*)
let add_card (p : t) (card_name : string) : t = {p with deck = p.deck @ [card_name]} 

let rec remove_card (card_name : string) (lst : string list) (count : int): string list =
  match lst with 
  | [] -> []
  | h::t -> if h = card_name then List.filteri (fun i _ -> i < count) lst @ List.filteri (fun i _ -> i > count) lst 
  else remove_card card_name t (count+1)

(**[swap] swaps the elemenet at pos1 with the element at pos2*)
let swap (arr : string array) (pos1 : int) (pos2 : int) = 
  let temp = arr.(pos1) in
  arr.(pos1) <- arr.(pos2);
  arr.(pos2) <- temp

(**[shuffle] shuffles a list*)
let shuffle (lst : string list): string list =  
  let arr = Array.of_list lst in
  for i = (Array.length arr - 1) downto 1 do 
    swap arr i (Random.int (Array.length arr));
  done; 
  Array.to_list arr

let new_deck (deck : string list) : string list = List.filteri (fun i _ -> i>4) deck
 
let new_hand (deck: string list) : string list = List.filteri (fun i _ -> i<=4) deck

(**[draw] updates the player's field whenever he draws*)
let draw (p : t) : t = 
  match List.length p.deck < 5 with
  | true -> let starting_deck = p.deck @ (shuffle p.used_cards) in {p with hand = new_hand starting_deck; deck = new_deck starting_deck; used_cards = []} 
  | false -> {p with hand = new_hand p.deck; deck = new_deck p.deck}

let change_health_player (p : t) (damage : int ) : t = { p with health = p.health - damage }

