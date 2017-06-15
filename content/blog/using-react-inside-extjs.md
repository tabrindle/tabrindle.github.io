+++
date = "2017-06-15T13:36:00-05:00"
draft = false
title = "Using React+JSX inside ExtJS"
slug = 'using-react-and-jsx-inside-extjs'
+++

## Intro

I won't even bother with my reasoning for doing this, because it's really not any different than the [last frankenstein hack-job](sencha-touch-extjs-with-es6) I did on ExtJS/Sencha Touch a while back. Long story short, I wrote an e-commerce app that grosses a few million a year, and don't have the bandwidth to rewrite it in newer technology. But I do want to be able to write React components, and share them across apps. Including inside my Sencha apps. So here I go. 

## Setup

The first step is to follow my old guide on using ES6+ in your app. Something like this:

- `sencha generate app {APP_NAME} ~/{DIR}/{APP_NAME}`
- `npm init`
- `npm install babel-preset-env --save-dev`
- set up babel config in package.json
- set up compile scripts in package.json
- create your new ES6 folder
- transpile

Now we actually start adding the react parts. You'll need to install a few more things in your package.json to get this to work, and modify your babel config too. 

`npm install babel-preset-react --save-dev`

This mostly allows us to transpile JSX. Next add this preset to your babel config:

```
  "babel": {
    "presets": [
      "react",
      [
        "env",
        {
          "targets": {
            "browsers": [
              "iOS >= 8",
              "Chrome >=46"
            ]
          },
          "include": [
            "transform-es2015-computed-properties"
          ],
          "loose": true,
          "modules": false
        }
      ]
    ],
    "comments": false
  },
```

Now to install React!

`npm install react react-dom --save`

This adds the React libraries to our dependencies, which actually get bundled in the final app. There are a couple ways to do this: if you are using webpack/rollup or some sort of bundler, you can include them there, but don't forget to also expose them as a global variable so that React and ReactDOM are available in window scope. 

Easiest though is probably just to add them as scripts in your index.html, and as part of your app.json resources to bundle. 

```
<script src="../node_modules/react/dist/react.min.js"></script>
<script src="../node_modules/react-dom/dist/react-dom.min.js"></script>
```

If you don't know how to make this work, you could always also just get them from a remote server, although I wouldn't recommend this. They aren't large scripts, but it will slow down startup.

```
<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.5.4/react.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/react/15.5.4/react-dom.js"></script>
```

The only thing that is left is to define a user extension component to use anywhere we want to use JSX for the component templates. 

```
Ext.define('Ext.ux.ReactComponent', {
  extend: 'Ext.Component',
  xtype: 'ReactComponent',
  constructor(...args) {
    this.callParent(args);

    const render = data => ReactDOM.render(this.config.jsx(data), document.getElementById(this.getId()));

    this.on('painted', () => render(this.config.data));
    this.on('updatedata', (component, data) => render(data));
  }
});
```

What is happening here is essentially we are taking the jsx property we will define on our new components, pass it the data from the component, and render it when painted and when we update the data. There may be better ways to do this, but it didn't occur to me at the time of writing. 

Now we can actually write something. Here is a simple test component, where we write some jsx, slap in some test data, and go. 

```
Ext.define('Shop.view.TestComponent', {
  extend: 'Ext.ux.ReactComponent',
  xtype: 'TestComponent',
  config: {
    data: [{
      foo: 1,
    }, {
      foo: 2,
    }],
    jsx: data => {
      return (
        <div>
          {data.map((val, idx) => <div key={idx} >foo: {val.foo}</div>)}
        </div>
      );
    }
  }
});
```

Bam. I got my React+JSX all up in your ExtJS. 

*Disclaimer* - Don't do this in production and cry because you broke something. I use this and my ES6 hack in production, but I wrote them. There is a reason that Sencha doesn't ship this with their products. It's very untested, and full of gotchas and holes in functionality.
