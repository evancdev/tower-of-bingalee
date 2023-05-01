open Card
open Player
open Random

exception InvalidPrompt of string

type t = { player : Player.t }

type change = {
  health_delta : int;
  energy_delta : int;
  gold_delta : int;
}

type prompt = {
  choice : bool;
  changes : change list;
  description : string;
}

let choice_p1 =
  {
    choice = true;
    changes =
      [
        { health_delta = 20; energy_delta = 0; gold_delta = ~-5 };
        { health_delta = ~-10; energy_delta = 0; gold_delta = 0 };
      ];
    description =
      {| As you enter through the door. You see a frail old man
sitting in one of the corners of the room. You reach your hand towards that man.
Suddenly, the man yelled and got up to his feet, alarmed at your presence.
"Hey! This is my spot in the queue! If you want to get in line, you're gonna have to
line up like everyone else. Confused, you look around and see that there are no one. You asked
the old man what was the queue for and responds, "For Office Hours for 3110 of course! How about this,
if you have 5 gold on you right now, I might be able to let you cut the line and go through. What do you say?" 
What should you do? |};
  }

let lucky_p1 =
  {
    choice = false;
    changes = [ { health_delta = 0; energy_delta = 1; gold_delta = 0 } ];
    description =
      {| You enter the door. A hooded figure is seen across from you and starts
  walking towards your direction. As he approaches you, he soon unveils his
  shround and reveals the practice exams needed to gain the upper advantage for
  your upcoming prelims! |};
  }

let unlucky_p2 =
  {
    choice = false;
    changes = [ { health_delta = ~-10; energy_delta = 0; gold_delta = ~-5 } ];
    description =
      {| You enter the door. It leads to a lecture hall filled with hundred of students.
  The door behind you slammed so loudly that everyone turned their heads towards you.
  You hurrily scurry away and lose some health out of embarassment. |};
  }

let prompts = [ choice_p1; lucky_p1; unlucky_p2 ]
let generate_random_prompt = List.nth prompts (Random.int (List.length prompts))

let apply_changes (state : t) (change : change) =
  change_energy_player
    (change_gold_player
       (change_health_player state.player change.health_delta false)
       change.gold_delta)
    change.energy_delta false

let read_decision (prompt : prompt) =
  let rec loop () =
    ANSITerminal.(print_string [ green ] (prompt.description ^ "\n"));
    ANSITerminal.(print_string [ yellow ] "Enter your choice (y/n): ");
    match String.trim (read_line ()) with
    | "y" | "Y" -> true
    | "n" | "N" -> false
    | _ ->
        ANSITerminal.(
          print_string [ red ] "Invalid choice. Please enter 'y' or 'n'.\n");
        loop ()
  in
  loop ()

let apply_prompt (state : t) (p : prompt) =
  if p.choice then
    match read_decision p with
    | true -> apply_changes state (List.nth p.changes 0)
    | false -> apply_changes state (List.nth p.changes 1)
  else apply_changes state (List.nth p.changes 0)

let get_player_state (state : t) = state.player
