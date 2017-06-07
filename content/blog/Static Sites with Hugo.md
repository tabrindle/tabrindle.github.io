+++
date = "2017-06-07T14:38:00-05:00"
draft = false
title = "Static Sites with Hugo"
slug = 'static-sites-with-hugo'
+++

In case you've been to my site before, you may have noticed that I'm not using Wordpress anymore. Good developers are lazy, but come on... not that lazy! In an effort to learn something new and not feel as bad about myself, I decided to take a look at a couple static site generators I had seen on Twitter. 

The top contenders are Jekyll, Hugo and Hexo, running on ruby, go and JavaScript. I love JS, hate Ruby's setup and installation woes (not to mention I have an extremely old version on MacOS to deal with), and haven't done much with Go. So, here we Go with [Hugo](https://gohugo.io)! (Sorry).

The basic first steps to getting a site going with Hugo

  - Create a repo on GitHub: yourusername.github.io
  - Install Hugo via `go get -v github.com/spf13/hugo` or `brew install hugo`
  - Run through Hugo's comprehensive [Quick Start](https://gohugo.io/overview/quickstart/)

Here is the interesting part - I don't want to have to go through some silly deployment process every time I write something, and I love CI, so I decided to try Travis CI. I have a lot of experience with Jenkins, and I can tell you that Travis is a breath of fresh air. Getting it configured was about 10 minutes of Google searching, and 3 test builds. 

The config is done through a `.travis.yml` in your repo, and really didn't require anything else but authorizing Travis to access your GitHub, and generating a personal token for Travis to use to write back to the repo. Best of all, Travis has a deploy property on its config file for a lot of [popular deployment providers](https://docs.travis-ci.com/user/deployment/#Supported-Providers) like AWS S3, GitHub pages, npm, Azure, GAE etc.

Here's my .`travis.yml`:
```
language: go
install: go get -v github.com/spf13/hugo
script: make clean build
deploy:
  provider: pages
  skip_cleanup: true
  local_dir: public
  fqdn: trevorbrindle.com
  target_branch: master
  github_token: $GITHUB_TOKEN
  on:
    branch: dev
notifications:
  email:
    on_failure: always
```

The secret here is have all of your source in something like a source or dev branch, and GitHub publishes the page from the master branch. The builds on Travis take about a minute, in spite of downloading and building Hugo, running it and deploying it to my GitHub page. Couldn't be happier!

And because I can:

[![Build Status](https://travis-ci.org/tabrindle/tabrindle.github.io.svg?branch=dev)](https://travis-ci.org/tabrindle/tabrindle.github.io)
