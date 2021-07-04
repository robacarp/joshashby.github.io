---
title: Web Extensions with Svelte and Rollup
layout: post
tags:
- svelte
- web-extensions
- rollupjs
- typescript
- tailwindcss
---

In most of my browser extensions, whether for transientBug, personal projects or one of my work contracts I inevitably end up needing some sort of UI. Historically I've used React and Parcel v1 due to the ease of entry into the space, however, this setup wasn't without it's issues. After a lot of experimenting with other stacks in the hopes of working past the issues, I've settled on a [Rollup.js](https://rollupjs.org/guide/en/) and [Svelte](https://svelte.dev/) based stack for newer project, and the experience has been amazing to say the least.

Today we'll walk through building a browser extension with a popup rendered by Svelte v3, and all bundled with Rollup v2; We'll include Typescript v4.3 and Tailwind CSS v2.2 as well since those are my go to tools and are also popular choices these days. And the best bit is that this extension will run in both Firefox and Chrome and be easily translatable to Safari, Chromium Edge, Vivaldi and other browsers that suppport the WebExtension API's.

In follow up posts we'll add a "[web accessible](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/web_accessible_resources)" page, options page and even a content script that injects a UI directly onto the current page, all rendered with Svelte, and styled with Tailwind CSS. Tailwind, PostCSS and 

#### Preface: The Why
Last year, as I was working on an extension using a React/Parcel v1/Tailwind CSS v1 setup when Tailwind CSS v2 was released, but to my dismay while upgrading Tailwind I found that it wasn't going to play nicely with Parcel v1, even with using the PostCSS v7 compatability build. Around this time I also found Svelte v3 and immediately fell in love.

Parcel v1 is suffering from being in a less than stellar maintenance mode for what feels like several years at this point, due to the team being focused on getting Parcel v2 out the door and as a result it's falling behind on integrations with tooling such as PostCSS. Tailwind V2 brought PostCSS v8 as a requirement, and Parcel v1 [will not be gaining](https://github.com/parcel-bundler/parcel/issues/5695) support for PostCSS v8. At this point I don't rememeber what other issues I ran into while trying to use the PostCSS v7 compatability build of Tailwind but it was enough to get me to start looking for alternatives.

After trying Parcel v2 and finding it still filled with bugs, edge cases and generally having a less than stellar time with it due to the plugin API constantly breaking which consequentally broke the Svelte plugin as well, I admittedly only glanced at webpack but passed due to a personal distaste for it. Because Svelte has a strong presence in the Rollup community (given that they're from the same author, Rich Harris, this makes a lot of sense) I decided to give it go.

While Parcel has the advantage of [existing](https://github.com/kevincharm/parcel-plugin-web-extension) [plugins](https://v2.parceljs.org/recipes/web-extension/) that allow you to use a browser extensions `manifest.json` file as the entry point, letting Parcel automatically find, process and bundle all referenced scripts, assets and other files, Rollup doesn't have such a plugin/library/helper at the moment. That said, while it's nice to have a single point of truth for what gets compiled, I've found Rollups config is simple enough that it's not too difficult to expand for new assets and it's fairly easy to automate if you so desire.

## Setup
After we're done with this section, our directory should look something like this:

```
.
├── src
│   ├── assets
│   ├── background
│   │   ├── index.html
│   │   └── index.js
│   └── manifest.json
├── package-lock.json
├── package.json
├── rollup.config.js
```

And we'll have a browser extension that loads a basic background page that logs "Hello, World" to the console. A background page is used in browser extensions to implement long running logic and shared state between tabs, you can read more about them on [MDN here](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Anatomy_of_a_WebExtension#background_scripts). Our extension today won't make heavy use of the background script for now, but we'll expand on uses for it in future posts.

<!-- tree -v --dirsfirst -I 'node_modules' -->

Make a directory where ever best fits for you and cd into it:

```shell
mkdir svelte-web-ext && cd svelte-web-ext
```

Go ahead and make `src/` and `src/assets/` in this directory too, as they'll come in handy later:

```shell
mkdir -p src/assets/
```

(The `-p` flag will create `src/` if it doesn't exist before creating `src/assets/`)

Then place the following into `package.json` and change the fields as necessary. We'll add to the scripts later on but it's okay to be left empty for now (You can also create this file by running `npm init` and answering the questions).

```json
{
  "name": "svelte-web-ext",
  "version": "1.0.0",
  "description": "",
  "scripts": {
  },
  "author": "",
  "license": "ISC"
}
```

Next lets install Rollup and some common plugins that we'll come in handy down the line:

- `@rollup/plugin-commonjs` Allows us to use CommonJS modules in our builds, especially for non-content scripts which will be bundled as ES modules.
- `@rollup/plugin-node-resolve` Along with the CommonJS plugin, this allows us to import packages installed with NPM.
- `@rollup/plugin-replace` To handle replacing common patterns, words and calls with a predefined format, such as replacing `process.env.NODE_ENV`.
- `rollup-plugin-copy` Will help us copy assets and the manifest file to our build directory.

```shell
npm i rollup @rollup/plugin-commonjs @rollup/plugin-node-resolve @rollup/plugin-replace rollup-plugin-copy --save-dev
```

We'll add more plugins as we go but this'll get us setup and running for now. Next we need to add some basic setup to our `rollup.config.js` to get our background page script `src/background/index.js` compiling. Today we won't do much with the background page script, but I'm using it here to get us up and running and we'll expand on some use of it in future posts.

```javascript
import commonjs from "@rollup/plugin-commonjs"
import replace from "@rollup/plugin-replace"
import resolve from "@rollup/plugin-node-resolve"
import copy from "rollup-plugin-copy"

const production = !process.env.ROLLUP_WATCH
if (production) process.env.NODE_ENV = "production"
const nodeEnv = process.env.NODE_ENV || "development"

export default [
  {
    input: "src/background.js",
    output: {
      sourcemap: !production,
      dir: "dist/background/",
      format: "esm",
    },
    plugins: [
      replace({
        preventAssignment: true,
        values: {
          "process.env.NODE_ENV": JSON.stringify(nodeEnv),
        },
        delimiters: ["", ""],
      }),
        
      resolve({ browser: true, dedupe: ["svelte"], preferBuiltins: false }),
      commonjs(),

      copy({
        targets: [
          {
            src: `src/manifest.json`,
            dest: "dist/",
          },
          {
            src: "src/background/index.html",
            dest: "dist/background/",
          },
          { src: "src/assets/", dest: "dist/" },
        ],
      }),
    ],
    watch: {
      clearScreen: true,
    },
  },
]
```

(One nice thing about Rollup is that the config file can be normal everyday ES6 syntax which means trailing commas, `import`/`export` statements and destructuring.)

Let's break this down:

```javascript
export default [
  // ...
]
```

In Rollup you can export either a single config object or an array of config objects. We'll jump straight to exporting an array of objects as we'll add another configuration for the pop-up page later which will include the Svelte plugin and have some different needs around what gets copied over.

```javascript
    input: "src/background/index.js",
    output: {
      sourcemap: !production,
      dir: "dist/background/",
      format: "esm",
    },
```

Here we're telling Rollup that we'll package `src/background/index.js` as an ES module (via `format: "esm"`), enabling or disabling sourcemaps according to if this is a production build, and place the output into `dist/background`. Rollup will take care of creating `dist/` and other directories if they doesn't exist which is why we didn't both with creating it before.

Finally let's take a look at the plugins we'll be using for `src/background/index.js`:

{% source javascript hl_lines="2 4" %}
      replace({
        preventAssignment: true,
        values: {
          "process.env.NODE_ENV": JSON.stringify(nodeEnv),
        },
      }),
{% endsource %}

As stated above, we'll being using the replace plugin to replace any occurance of `process.env.NODE_ENV` with the value of `NODE_ENV`. This might seem weird to have to do manually if you're coming from Webpack or Parcel, but it's a minimal addition to our config that I don't mind having. We're also telling the plugin that if it detects an assignment to `process.env.NODE_ENV`, it shouldn't replace it with our hard coded string, via the `preventAssignment` option. 

{% source javascript hl_lines="2 3 4" %}
      resolve({
        browser: true,
        dedupe: ["svelte"],
        preferBuiltins: false
      }),
      commonjs(),
{% endsource %}

We need to tell the resolve plugin to act a little differently since we're bundling for a browser, by using any browser configurations found in imported `package.json`, to resolve `svelte` to a single node module (I haven't found an issue with leaving this out, but the official [Svelte Rollup](https://github.com/sveltejs/template/blob/f92a0a4dfda3a4eff6474ca242c8aea4be9260d1/rollup.config.js#L57) config uses it so I leave it in for now) and to not try and use Node built ins.

**A Note:** I've personally had issues with the node built ins and haven't been able to get polyfills or remove the `preferBuiltins` flag, but it's only really effected a small number of packages that I have found alternatives for. If anyone has advice on how to get these to play nice together, shoot me a message and I'll give it a go and update this post!

{% source javascript hl_lines="4 8 11" %}
      copy({
        targets: [
          {
            src: `src/manifest.json`,
            dest: "dist/",
          },
          {
            src: "src/background/index.html",
            dest: "dist/background/",
          },
          { src: "src/assets/", dest: "dist/" },
        ],
      }),
{% endsource %}

And finally we copy over some files. We don't want `dist/` hanging out in our repository so we'll copy it over from `src/`, so that it stays closer to the files it references. Additionally, we'll copy over an HTML file for `src/background/index.js` to live in (more on this in just a second), and finally we'll copy over all assets while we're at it; I throw fonts, SVGs, Logos and more into `src/assets/`.

We also need to add `src/background/index.js` and `src/background/index.html`. Because we're using ESM as the format for the bundled `dist/background/index.js` file, we'll use the `index.html` file to load the module to avoid issues. They'll look like this:

```javascript
console.log("Hello, World!")
```

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />

    <title>Svelte Web Ext</title>

    <script type="module" src="./index.js"></script>
  </head>

  <body></body>
</html>
```

The `type="module"` attribute on the `<script>` tag is the magic to get our ESM bundle to work.

Finally, the last part before we can fire up Rollup and give this a go, the magic [`src/manifest.json`](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json) file:

```json
{
  "manifest_version": 2,
  
  "version": "1.0.0",
  "name": "Svelte Web Ext",
  "description": "",

  "background": {
    "page": "background/index.html"
  }
}
```

The `manifest.json` file has to appear at the root of the packaged browser extension and informs the browser about scripts, permissions, and more that the extension requires. For now, the most important bit is the value of the `background` key. The `background.page` key tells the browser that it doesn't need to create it's own generic HTML page and should instead load our HTML from above which will load our script as an ES module without issue.

Finally, lets add two scripts to our `package.json` to help us run Rollup in development and production modes:

{% source json hl_lines="2 3" %}
  "scripts": {
    "start:rollup": "rollup -c -w",
    "build:rollup": "rollup -c"
  },
{% endsource %}

The `-w` flag tells Rollup to watch the files and rerun the build if anything changes, which comes in handy with developing and iterating.

With all that done, let's give this extension a go and make sure things are working:

```shell
npm run start:rollup
```

If everything looks good, you should see:

```
rollup v2.52.7
bundles src/background/index.js → dist/background...
created dist/background in 14ms

[2021-07-04 14:59:16] waiting for changes...
```

And now the moment of truth, does it run? We'll cover both Firefox and Chrome and the process here for loading the development build of the extension won't change as we add more features and functionality.

##### Firefox
In Firefox, type in `about:debugging` into the URL bar and press enter; On the left hand sidebar, select "This Firefox."

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-1.png)

There should be a button labeled "Load Temporary Add-on..." but if it's not visible, you might need to click on the "Temporary Extensions" section to expand it and display the button.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-2.png)

Click on the button and navigate to your built `dist/` directory and select the `manifest.json` file to load it your extension. 

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-3.png)

Next, click on the "Inspect" button on the newly loaded.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-4.png)

This'll open up a new tab with a developer console and you should see our "Hello, World!" printed out!

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/firefox-step-5.png)
##### Chrome
In Chrome, type in `about:extensions` into the URL bar and press enter. You might need to make sure that that "Developer mode" switch is turned on in order to see the button "Load unpacked"

Click on "Load unpacked" and navigate to your extensions directory and select the `dist/` directory to load your extension. 

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-1.png)

Next, click on the "background/index.html" link to open the developer console to the background page's context.

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-2.png)

This'll open a new window with the developer tools for the extensions background page, you might have to navigate to "Console" but you should see out "Hello, World!" printed out!

![](/assets/2021-07-03-web-extensions-with-svelte-and-rollup/chrome-step-3.png)


### Svelte
Now that we've got the ground work down with Rollup building our extension, we'll get Svelte installed

### TypeScript
If you'd like to not use TypeScript, it's safe to skip this section. The rest of the code in the Svelte components will be TypeScript, but it should be easy enough to remove the typings and be running with pure JS.
###  PostCSS and Tailwind CSS
If you'd like to not use PostCSS or Tailwind CSS, it's safe to skip this section. The rest of the styling in the Svelte components will be using Tailwind, but it should be easy enough to convert them to whatever CSS format you want to run with.

## Pop-up Page
