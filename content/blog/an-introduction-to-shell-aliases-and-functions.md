+++
date = "2019-03-21T17:00:00-05:00"
draft = false
title = "An Introduction to Shell Aliases & Functions"
slug = 'an-introduction-to-shell-aliases-and-functions'
+++

- Is there a task that you repeat a lot?
- Is this a task that only you repeat, or is done in a way personal to you?
- Do you want to use a command in every directory on your computer?

## Use a Shell Alias!

An alias is simply a shortcut to a command. Use it to avoid typing many options, many commands, or anything that's just too many keystrokes. 

One of the most common examples is `ls`. Say you use `ls` a lot, but always want more information than the standard output. You might add a couple options, like `ls -la`. Check out the man page of `ls` with `man ls` for more option ideas.

You can create a shell alias to shortcut these options. Type this into your terminal:

`alias lsla='ls -la'`

Now, when you type `lsla`, `ls -la` will be executed. 

In fact, you can even use aliases to override builtins and other commands, like this:

`alias ls='ls -la'`

Though it can be useful, I don't recommend always overriding commands because it's easy to forget your options once you're not using them every day, and one day you'll be helping out a friend and feel silly because your aliases aren't there. 

But, uh oh. Next time you open your terminal, your aliases are gone. Terminal session aliases can be useful too, but most of the time I want my aliases every time I open my terminal.

## How to get started

To use your aliases every time you open your terminal, this requires adding them to your .bashrc (or .zshrc etc if you use a different shell like zsh) 

If you don't already have this file, create it like this, then open in your text editor. 

`touch ~/.bashrc`

Paste in a handy alias like this one - `alias mkdirp='mkdir -pv'` (This automagically creates parent directories as needed instead of showing an error)

Then in your terminal, run:

`source ~/.bashrc`

Now, in your current terminal session, and every one after that where your .bashrc is automatically sourced, your `mkdirp` command will be there.

## My favorites

I like to consider myself a speaker, and while live demos are awesome, there are so many things that can go wrong. So when I demo, I cheat a little, and use [asciinema](https://asciinema.org/) to record the terminal session. Then, I use an alias to make it look like I'm typing the commands:

`alias demo='asciinema play ~/Developer/demo/envinfo.cast'`

Being a frequent web developer, I tend to use port 8000 for a lot of things, and we all know that strange situation where something crashed, but the port is still in use. Use this alias to find the process that is tying up port 8000 and kill it. 

`alias kill8000='lsof -ti tcp:8000 -sTCP:LISTEN | xargs kill'`

Not everyone uses a git UI, but sometimes it's really great to be able to see the git log graph. This alias has a lot of options and colors set up to make it easier and more fun to read. 

`alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(red)%h%C(r) —— %C(bold blue)%an%C(r): %C(white)%s%C(r) %C(dim white) %C(bold green)(%ar)%C(r) %C(bold yellow)%d%C(r)' --all"`

## Shell Functions

There are so many other things you can do with aliases, but you really shouldn't create multiline aliases or try to use variables in them. That's what shell functions are for. For example:

```
wtfport() { 
  sudo lsof -i :"$1" 
}
```

This is a bit like the above alias `kill8000`, but takes an argument of a port number and tells you what process is using that port. This is probably a little bit safer than just killing it. 

I use git every day. And making sure I'm not adding huge snapshots accidentally, and keeping code reasonably succinct is important to me, so I wrote this function for git. This checks the git subcommand run to see if it is status, and if it is, runs another command to tell me the total added and removed lines of code. 

```
git() {
  if [[ "$1" = "status" ]]; then
    command git status;   
    command git --no-pager diff --shortstat HEAD
  else
    command git "$@"
  fi
}
```
Run `git status` and something like this is returned. `3 files changed, 16 insertions(+), 10 deletions(-)`

I make gifs all the time for demos on pull requests, and macOS has a handy built in screen recorder (use command + shift + 5). However, it records in .mov format, and I usually need a gif. While I am aware there are about a thousand different applications that do this, I already have ffmpeg and imagemagick on my computer. This function produces a reasonably optimized, high quality gif using a command like: 

`gif ~/Desktop/test.mov`

```
gif() {
  ffmpeg -i "$1" -vf "fps=25,scale=iw/2:ih/2:flags=lanczos,palettegen" -y "/tmp/palette.png"
  ffmpeg -i "$1" -i "/tmp/palette.png" -lavfi "fps=25,scale=iw/2:ih/2:flags=lanczos [x]; [x][1:v] paletteuse" -f image2pipe -vcodec ppm - | convert -delay 4 -layers Optimize -loop 0 - "${1%.*}.gif"
}
```

Ask anyone who's been programming for a few years on some kind of linux or unix machine, and they'll have a few of these handy aliases and functions. Good luck, and go forth and `alias`! Also, tweet me your best aliases @trevorbrindlejs!

Psst - store your aliases in a git repo ;-)