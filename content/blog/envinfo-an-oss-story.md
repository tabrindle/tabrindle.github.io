+++
date = "2018-03-19T00:00:00-05:00"
draft = false
title = "envinfo: an OSS story"
slug = 'envinfo-an-oss-story'
+++

_Sometimes finding your place in OSS is totally accidental. This is the story of envinfo: an environment information gathering and debugging tool. It’s how I found my place in open source, and this is where I’m going with it from here._ 


The best ideas are the simplest; and this notion becomes no more clear than when you have one of those ideas. Well, you really can’t get any more simple than envinfo. It may be a useful tool, but is nothing more than a conglomeration of  `--version`  commands. It didn’t take expert level technical skills to write, and the code is nothing incredible to behold. Yet, it was necessary, and fills a gap in the tech community that somehow we all didn’t see. Here it is:

> **Please mention other relevant information such as the browser version, Node.js version, Operating System and programming language.**

## Issue reporting on GitHub

A few months ago, I was reading through React Native issues on GitHub, and I noticed often critical debugging information was missing. Come on guys, how hard is that? Type `node --version` into your terminal. Well that’s the point - it’s not hard, but it can be tedious. **But we are engineers; it's in our job descriptions to simplify complex things, or shorten tedious tasks.** So, I wrote a PR for React Native that does exactly this. I changed the CLI to call those commands all in one spot, and updated the issue template to say run `react-native info`

```
Environment:
  OS: macOS High Sierra 10.13
  Node: 8.9.4
  Yarn: 1.3.2
  npm: 5.6.0
  Watchman: 4.9.0
  Xcode: Xcode 9.0 Build version 9A235
  Android Studio: 3.0 AI-171.4443003

Packages: (wanted => installed)
  react: ^16.3.0-alpha.1 => 16.3.0-alpha.1
  react-native: 0.54.1 => 0.54.1
``` 

Easy peasy. But here was the problem. My PR sat waiting for review for several weeks. And let’s be honest - this was not a flashy new feature, or a critical bugfix. Such is life when you work on boring developer experience tools. But, the React Native maintainers are incredibly busy, doing amazing work, so I rethought my plan. More projects could benefit from something like this. I thought perhaps adding this code directly into the react native cli was not the way to go. Creating my own package would streamline PRs like this, and it could give me a lot more control.

## Learning from the best: Ionic CLI

Some projects already have an info or diagnostics command: in fact I got the idea from Ionic. `ionic info` was the first time I had a really excellent environment debugging experience, and I hoped to recreate that in a generic package. This is how envinfo was born. Its aim is to quickly get development environment information, make it easy to use and simple to integrate with anyone’s tools. 

Here it is: [envinfo](https://github.com/tabrindle/envinfo)

## React, Jest, Styled-Components, oh my.

Once I wrote the package and got it merged in React Native, that’s when everything changed. I realized I was a contributor to React Native, but knew next to nothing about it - and didn’t really have to in order to help. I started filing issues in other projects that I used that were high traffic and I felt could benefit from a streamlined issue reporting process. **Soon enough, [Create React App](https://github.com/facebook/create-react-app), [Expo](https://github.com/expo/expo), [Solidarity](https://github.com/infinitered/solidarity), [Styled Components](https://github.com/styled-components) and [Jest](https://github.com/facebook/jest) were all using envinfo in some way, and the maintainers were stoked.**

> Love it! Please send a PR :)

> Perfect idea! 

> This is great, want to put the PR in?

I’m not going to lie, I was more than a little excited. These were framework writers that I had always looked up to. They liked my idea, and best of all, they had ideas on how to make it better! 

Dan Abramov, a React core contributor and the author of [Redux](https://github.com/reduxjs/redux), gave me the idea to look for duplicate packages in the `node_modules` directory. 
[Gant Laborde](http://gantlaborde.com/) (the creator of [Solidarity](https://github.com/infinitered/solidarity), a project based environment checker) gave me the idea for, and even a PR for, checking Android SDK versions.

While discussing adding envinfo to Jest’s issue template, I had the idea to create project specific presets. This would cut down on the number of commands people will have to type or copy/paste. 

Now, for new projects, create a new preset in envinfo, and this is all you might have to do:

```
$ npx envinfo@latest --preset styled-components


 System:
    OS: macOS High Sierra 10.13
    CPU: x64 Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
  Binaries:
    Node: 8.9.4
    Yarn: 1.3.2
    npm: 5.6.0
  Browsers:
    Chrome: 65.0.3325.146
    Firefox: 58.0
    Safari: 11.0
  npmPackages:
    styled-components:
      wanted: ^3.1.6
      installed: 3.1.6
    babel-plugin-styled-components:
      wanted: ^1.5.1
      installed: 1.5.1
```

But envinfo can do a lot more than just that. In fact, envinfo can do quite a lot. Try this in a React Native project directory:
  
```
$ npx envinfo@latest --all

System:
    OS: macOS High Sierra 10.13
    CPU: x64 Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
    Free Memory: 1.13 GB
    Total Memory: 16.00 GB
    Shell: /usr/local/bin/bash - 4.4.12
  Binaries:
    Node: 8.9.4
    Yarn: 1.3.2
    npm: 5.6.0
    Watchman: 4.9.0
  Virtualization:
    Docker: 17.12.0-ce, build c97c6d6
    Parallels: 13.3.0
    Virtualbox: 5.2.6r120293
    VMware Fusion: 10.1.1
  SDKs:
    iOS:
      Platforms: iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0
    Android:
      Build Tools: 27.0.3
      API Levels: 26
  IDEs:
    Android Studio: 3.0 AI-171.4443003
    Atom: 1.23.3
    VSCode: 1.21.0
    Sublime Text: Build 3143
    Xcode: Xcode 9.0 Build version 9A235
  Languages:
    Bash: 4.4.12
    Go: 1.9.3
    Elixir: 1.6.2
    PHP: 7.1.7
    Python: 2.7.10
    Ruby: 2.3.3p222
  Browsers:
    Chrome: 65.0.3325.146
    Chrome Canary: 67.0.3368.0
    Firefox: 58.0
    Firefox Developer Edition: 57.0
    Firefox Nightly: 58.0a1
    Safari: 11.0
    Safari Technology Preview: 11.1
  npmPackages:
    babel-jest:
      wanted: 22.4.1
      installed: 22.4.1
    babel-preset-react-native:
      wanted: 4.0.0
      installed: 4.0.0
    jest:
      wanted: 22.4.2
      installed: 22.4.2
    react-test-renderer:
      wanted: ^16.3.0-alpha.1
      installed: 16.3.0-alpha.1
    react:
      wanted: ^16.3.0-alpha.1
      installed: 16.3.0-alpha.1
    react-native:
      wanted: 0.54.1
      installed: 0.54.1
  npmGlobalPackages:
    create-react-native-app: 1.0.0
    envinfo: 4.2.1
    exp: 49.2.2
    install-subset: 3.0.0
    lerna: 2.7.1
    npm: 5.6.0
    npm-check-updates: 2.14.0
    react-native-cli: 2.0.1
    solidarity: 2.0.2
```

Wow, that’s a lot of information. Some of it is easy to find. Some of it is tricky to find, especially across platforms. Some of it simply has never been coalesced into this format before. Speaking of formats, you can use yaml, json, or even markdown as an output. Handy. 

```
$ npx envinfo@latest --preset jest --markdown

## System:
 - OS: macOS High Sierra 10.13
 - CPU: x64 Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
## Binaries:
 - Node: 8.9.4
 - Yarn: 1.3.2
 - npm: 5.6.0
## npmPackages:
### jest:
 - wanted: 22.4.2
 - installed: 22.4.2
```

## Your place in Open Source

So what am I saying with this? Don’t feel like you need to write some flashy new framework that does all the things. Don’t feel like you have to know everything about a project to be able to contribute. **Start with a simple idea, or a simple problem and solve it.** It doesn’t have to be beautiful. It doesn’t have to be impressive or complex, but it has to be useful. Remember that there is no need to implement everything all at once.

envinfo is neither beautiful, nor complex, and I’ve mostly written it while waiting for other projects to build. But, it's simple, effective and now part of many major projects, has 600,000+ monthly downloads and is catching on fast. If you think of something you want to see in envinfo, [file an issue](https://github.com/tabrindle/envinfo/issues), or [send a PR](https://github.com/tabrindle/envinfo/pulls)!
