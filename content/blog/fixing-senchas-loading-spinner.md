+++
date = "2015-05-20T18:00:00-05:00"
draft = false
title = "How to fix Sencha's loading spinner after Chrome 43"
slug = 'fixing-senchas-loading-spinner'
+++

With Chrome 43, much more than just lists were broken with Sencha. Most recently I noticed the standard loading spinner no longer animates. From my travels through this code before, I knew that it was animated using keyframes, and was in sort of a strange spot (Class.scss in the base theme). So I thought I would start my hunt there. As it turns out, Chrome is moving away from preferring -webkit vendor prefixes on implementations that are now standardized, and it's causing things to break. Either because the original programmer was lazy, or simply didn't understand how vendor prefixes work. Sorry to whomever wrote that code originally, I usually have the same mentality that if it works, it's right. Now that Chrome isn't so flexible, we are out of luck.

I highly recommend this article to explain what they are and how best to deal with them. It gives a number of tips that are helpful and the last, most easily overlooked one perhaps being the most important:

Another mistake is letting CSS get stale. As I mentioned earlier, it's worth a look at CSS older than a couple of months to make sure it's up to snuff.

Given that browsers jump versions every few weeks, you're bound to find some things that have changed, and some places to prune some old code. In any case, I found this bug report that a helpful soul from the chromium team pointed out that Chrome is now choosing the non-prefixed keyframe declaration for the loading spinner, but then finding no non-prefixed or -webkit statements there, only -ms. By either adding non-prefixed transform statements to this code (or if you are lucky enough to not have to support IE deleting the block entirely) you can fix this.

Old:
```
@keyframes x-loading-spinner-rotate {
    0% {
        -ms-transform: rotate(0deg);
    }
}
```

New:
```
@keyframes x-loading-spinner-rotate {
    0% {
        transform: rotate(0 deg);
        -ms-transform: rotate(0 deg);
    }
}
```