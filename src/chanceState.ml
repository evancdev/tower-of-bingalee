open Card
open Player
open Random

type t = {
  cards : string list;
  gold : int;
  player : Player.t;
}

let decision_prompt1 =
  {| As you enter through the door. You see a frail old man
sitting in one of the corners of the room. You reach your hand towards that man.
Suddenly, the man yelled and got up to his feet, alarmed at your presence.
"Hey! This is my spot in the queue! If you want to get in line, you're gonna have to
line up like everyone else. Confused, you look around and see that there are no one. You asked
the old man what was the queue for and responds, "For Office Hours for 3110 of course! How about this,
if you have 5 gold on you right now, I might be able to let you cut the line and go through. What do you say?" 
  What should you do? |}

let lucky_prompt1 =
  {| You enter the door. A hooded figure is seen across from you and starts
  walking towards your direction. As he approaches you, he soon unveils his
  shround and reveals the practice exams needed to gain the upper advantage for
  your upcoming prelims! |}

let unlucky_prompt1 =
  {| You enter the door. It leads to a lecture hall filled with hundred of students.
  The door behind you slammed so loudly that everyone turned their heads towards you.
  You hurrily scurry away and lose some health out of embarssment. |}

let prompts = []
