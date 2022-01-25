![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.1.0-orange.svg)
![Godot Version](https://img.shields.io/badge/godot-3.1-brightgreen.svg)
![Status](https://img.shields.io/badge/status-beta-blue.svg)

# Archived Notice
Hey everyone! When I first wrote Whiskers it was meant to be used as a stateful editor to create really simple text based adventure games - which it did pretty well! But my code quality in this MR just isn't that great, so the application can be pretty buggy! While I meant to re-make this at some point using best practices, its just not really on my agenda for any time soon so I've decided to `archive` this project since development on it is no longer going on (and hasn't been for quite some time)

If you're looking for a dialogue editor for Godot, there are lots of really solid options out there! I just discovered this one and it looks pretty solid!

https://github.com/nagidev/DialogueNodes


There are also some really great addons for adding `Ink` and `Yarn` support, which I definitely suggest checking out since they're both well established and battle tested tools.

If you'd like to keep up with what I'm working on these days, you can check out [my really cool twitter](https://twitter.com/LittleMouseDev) where I post Dev Logs of prototypes I'm building


So long and thanks for all the ~~fish~~ cheese 🐭


<img src="/logo.png"  width="170" align="right"/>

# What is Whiskers?
Whiskers is an Open Source, visual Dialogue editor made using Godot.

![Media](/media.png)

# How do I use this?
We've included a few example projects in `/examples` to get you started! Play around with them to understand what each node does, and how they interact with each-other!

It is ***very*** important that you connect ***all*** dead-end nodes to an `End` node! Or else your dialogue asset won't save properly and it'll run into issues while parsing! This can cause you to ***lose all unsaved progress!***

This project is still being developed, and you *will* encounter bugs! Please be sure to report all issues to this Repository so we can get them fixed ASAP!

# How do I use an exported Dialogue Assets?
There's an awesome parser [GDScript class here](https://github.com/LittleMouseGames/whiskers-parser), which should get you up and running using Whiskers Dialogue assets lightning quick!

# How can I help?
The best way to help is to use Whiskers and give me your suggestions and feedback! Pull-requests are always welcome!

Please follow the [GDScript Style Guide](https://docs.godotengine.org/en/3.0/getting_started/scripting/gdscript/gdscript_styleguide.html) when submitting pull-requests! Thank you!

# Why did you make Whiskers?
There are lots of awesome Dialogue creation tools out there, but I like a good challenge! Creating this tool taught me a *lot* about Godot. Having created my own solution also means that I can add new Features much quicker than if I was using a third-party one!
