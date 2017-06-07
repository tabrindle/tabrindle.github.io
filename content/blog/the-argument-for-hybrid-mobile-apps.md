+++
date = "2014-04-23T21:51:00-05:00"
draft = false
title = "The argument for Hybrid Mobile apps"
slug = 'the-argument-for-hybrid-mobile-apps'
+++

## Native is better at a lot of things.

Working in this field, you get a lot of native developers trying to convert you. Then they get confused when you refute only some of their points. More features, better performance, and a lot of developer talent out there. There are things in native that you just can't do with web technologies like HTML, JavaScript and CSS. But that doesn't always mean its the best idea. In business, one's first responsibility is always to assess needs, and subsequently, cost. In the current environment of everything in business moving to mobile, what do we really need native APIs for? Heavy data processing, graphics, cameras, location access, etc. But a lot of business apps don't have flashy graphics, need the camera or care where you are. This means that most of the time native just isn't necessary, especially when you are dealing with apps that replace a paper process; a request for time off form, for example.

## But here's why you'll go hybrid

The time to live on a dual OS hybrid app is incredibly short, in comparison to two native projects . Web developers are everywhere. Javascript frameworks are incredibly easy to learn. and most importantly Native features aren't always necessary, and when they are, you have Cordova. Say you have a project that needs to support iOS and Android. You can have 1 developer, and 3 months for a sizable e-commerce app that already has a backend API, but doesn't require anything from a native library . Even if you manage to hire a rockstar native developer that speaks Objective-C and Java, you're going to have a hard time getting two projects out on time, tested and ready to go, with similar user experiences and branding. With Hybrid, that's possible. How would I know? I did it.

## How hybrid works

Using a JavaScript SPA framework like Angular or Ember, and a JavaScript/Native bridge like Apache Cordova, a developer can create a cross-platform app in a fraction of the time of multiple native projects. It's the job of these frameworks to deal with the differences in platforms so you are only writing the common code. You spend time writing your business logic, not fighting with device or OS quirks. You essentially create a webapp, then nest it inside of a native webview that is started on app launch. Simple as that. If you do it right, your average user will never know the difference.

## Nope, it's not perfect.

Hybrid apps suffer from the same drawbacks that other webapps would. Heavy DOMs mean slow apps, no matter what device you're on. Both iOS and Android's webview may be rooted in WebKit, but that doesn't mean they always react the same way. Sometimes you'll have to stick a conditional here and there to account for iOS7's transparent status bar, for example. However, this is less and less common as JavaScript frameworks mature and progress.

But it works, and that's what businesses need.