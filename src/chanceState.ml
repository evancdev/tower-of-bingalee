open Card
open Player
open Random

exception InvalidPurchase of string
exception CannotSell of string

type t = {
  cards : string list;
  gold : int;
  player : Player.t;
}

let floor = 1
let tier1 = []
let tier2 = []
let tier3 = []

let luckyprompt_1 =
  {| As you enter through the door. You see a frail old man
sitting in one of the corners of the room. You reach your hand towards that man.
Suddenly, the man yelled and got up to his feet, alarmed at your presence.
"Hey! This is my spot in the queue! If you want to get in line, you're gonna have to
line up like everyone else. Confused, you look around and see that there are no one. You asked
the old man what was the queue for and responds, "For Office Hours for 3110 of course! How about this,
if you have 5 gold on you right now, I might be able to let you cut the line and go through. What do you say?" 
  What should you do? |}
