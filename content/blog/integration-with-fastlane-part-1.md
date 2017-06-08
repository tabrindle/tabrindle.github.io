+++
date = "2017-05-22T12:00:00-05:00"
draft = false
title = "Integration with Fastlane: Part 1 - Hockeyapp"
slug = 'integration-with-fastlane-part-1'
+++

## Hockeyapp

Hockeyapp is an awesome service provided by Microsoft, mainly for internal application distribution.
You can also integrate code push, and crash reports, and all sorts of other really nifty things. 
Integration with Hockeyapp is quite easy with Fastlane, as there is a dedicated action built 
in. You simply call `hockey` in your fastfile, provid it some config, and you're off. Using lane 
context, you can minimize the amount of config you have to pass, especially if you call it right
after `gym`. Gym provides a lot of the necessary information, by design. 

Your build flow could be as simple as this:
```
lane :alpha do
    sigh
    gym
    hockey
  end    
```

Keep in mind here, you will probably have to add some configuration in your gymfile, and possibly pass 
in environement variables for the Hockeyapp API keys. 

Or in my case where sometimes there are a bunch of other processes in between, or may need to be done
at a different time than the build, one can pull from a common build folder, where builds are archived by date.

In this example, we are pulling from a build folder, and adding release notes based on the build number
and branch. Environment variables like BUILD_NUMBER are often injected by CI tools, like in this case, Jenkins. 
```
  lane :hockeyapp do |options|
    date = Time.now.strftime('%F')
    time = Time.now.strftime('%T')
    build_number = ENV["BUILD_NUMBER"] ? "Build " + ENV["BUILD_NUMBER"] : ""
    hockey(
      ipa: "build/#{date}/app-development.ipa",
      dsym: "build/#{date}/app-development.app.dSYM.zip",
      notes: "#{build_number} From #{git_branch} branch on #{date} at #{time}",
      notify: "0"
    )
  end
```

This way, there can be two hockeyapp lanes - one for each platform, which can be invoked and work
regardless of how the project was built: Via command line with whatever framework you use, through 
your IDE like Xcode or Android Studio, directly through build tools like xcodebuild or gradle, or
even fastlane itself.

## Builds

In order to easily maintain an archive of builds, in all of my projects, a .gitignore'd folder in the project's
root called "builds". This is useful for decoupling all of the Fastlane commands so that they can be use all 
together, or only parts.

Example build directory:
```
├── 2017-05-01
│   ├── app-development.app.dSYM.zip
│   ├── app-development.ipa
│   └── app-debug.apk
└── 2017-05-07
    ├── app-development.app.dSYM.zip
    ├── app-development.ipa
    └── app-debug.apk
```

## React Native

Another amazing OSS project that moves very quickly is React Native, and itworks very well with Fastlane. 
At heart, React Native projects are just iOS and Android projects, but there are a couple gotchas that 
you will need to take care of for them to work with Hockeyapp. 

React Native bundles all of its JavaScript into a file called `main.jsbundle`, but currently the bundler
[does not allow much configuration](https://github.com/facebook/react-native/issues/14400), as all the 
config is tied to the native project's build process There are work arounds, but the crux of it is, 
the bundler has to be set to create an offline JS bundle rather than relying on a development server, and 
you have to build with a non-release certificate for iOS and no signing for Android. 

On iOS, this means using an ad-hoc signing certificate, otherwise the Release configuration will choose an appstore
profile. Even though this is not actually being released to the appstore, we must choose the release
configuration so that an offline jsbundle is created. 
```
  lane :development_build do
    match(type: 'adhoc')
    gym(
      clean: true,
      configuration: "Release",
      export_method: 'ad-hoc',
      include_bitcode: false,
      include_symbols: true,
      output_directory: "build/" + Time.now.strftime('%F'),
      output_name: "app-development.ipa"
    )
  end
```

For Android, you have to modify the `$PROJECT/android/app/build.gradle` file to add this:
```
if ( project.hasProperty("bundleInDebug") ) {
    project.ext.react = [
        bundleInDebug: true
    ]
}
```

This allows you to optionally tell the bundler to create an offline bundle for a debug build. Then we can 
use Fastlane to call gradle like this:
```
  gradle(
      task: "assemble",
      build_type: "Debug",
      project_dir: "android",
      properties: {
        "bundleInDebug" => true
      }
  )
```

Notice here we can actually choose the Debug build_type, as we have also passed in the bundleInDebug hasProperty
that will trigger that new block in the build.gradle to create an offline bundle. 

Of note, I have submitted an issue on GitHub for React Native (as referenced above) to possibly solve these 
issues in the tooling. Once that is resolved, setting up Hockeyapp for React Native should be a lot easier!

**If anyone has an easier way of doing this, or spots a typo, drop me a line!**

For more examples of other parts of Fastlane, please take a look at [Fastlane Examples](https://github.com/fastlane/examples)
on GitHub.