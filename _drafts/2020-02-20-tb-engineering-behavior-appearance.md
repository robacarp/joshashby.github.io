---
title: 'transientBug Engineering: Client Behaviors'
layout: post
---

This is the first of a possible series on my experiences and learnings from building transientBug. If you like it, feel free to send me one of those electronic mail things letting me know.

<hr />

We've all been there, you have a totally server side rendered site but you still want to introduce some dynamic experiences on the frontend. Turns out, there are a lot of ways to climb this mountain:

* You might just jump to VueJS or React
* You could go lighter and use something like [stimulus.js](https://stimulusjs.org/)
* You might reach for jQuery, or these days even vanilla JavaScript
* You could look into something like [intercooler.js](https://intercoolerjs.org/)
* Your web framework, if you're using one, might have something like Server-rendered JavaScript Responses
* etc, etc

All of these obviously have their pros and cons, but there is one last (and perhaps worst of them all) way: maybe you're like me and you ~want~ like to reinvent the wheel 17 times over in different shades of "should have used XYZ." And so our adventure starts on the many hours I've dumped into figuring out a pattern for dynamic experiences that works for me while developing transientBug.

As a bit of history and stack background: transientBug is Rails backed and started on Rails 4 with the sprockets asset pipeline, but these days it's a Rails 6 with webpacker AND sprockets, with sprockets being slowly deprecated. The JS assets handled by sprockets is a mad mixture of pre-junior grade jQuery and lack of direction while the webpacker code is starting to shape up into something worth iterating on and not nuking from orbit. The gap between the two setups holds an awful lot of personal and career growth for me; the kind of thing that lends itself towards knowing what works for you and your personal preferences. Now, to be clear, all of what I've thrown together over the years isn't really necessary, and there are certainly better or easier ways that I could have gone about it but a lot of that growth came out of using tB for experiements.

So what is the use case for what will get built in this post? Some simple dialogues for deleting and editing bookmarks in bulk.

The problem I want to solve is to avoid having markup split between codebases: With my older react solutions, and everything before it all the way back to the first solution I built in jQuery, I kept running into the same problem: The markup for buttons, paragraphs and other elements were all duplicated in EJS templates or JSX files and the normal HAML templates in Rails. Even with shared CSS this still led to small inconsistencies and a general discomfort with the lack of developer ergonomics. Ideally I could have all the markup stay in HAML with behavior being attached to plain-old HTML elements on the browser with some easy to use but modular JS. I'm okay with having behavior being split between code-bases because it lets me keep the backend a lot slimmer by avoiding a bunch of direct UI/UX concerns, such as "send some SRJ for a dialog when a POST to the special xyz endpoint was made," and I believe that backend behavior differs from frontend UI/UX enough that it makes sense and causes less overall confusion.

Lets look at an ideal situation for me compared to some solutions:

{% highlight haml linenos %}
%button( data-behavior="open-dialog", data-dialog-id="bulk-delete" )
  Bulk Delete

%dialog#bulk-delete
  %header
    -# Dialog title and a close button could be here
  %section.dialog-main
    -# A table of records or some confirmation message might live here
  %footer
    -# Some actions as buttons or links could be here
{% endhighlight %}

This looks pretty sane to me, for an app where most of the functionality is server side. If I want to change the dialog, I can quickly change it, remove it or duplicate it. Using partials this could be all cleaned up and reduced really easily, while still leaving customization open with `yield` or `content_for` blocks. I can change the markup of the trigger from a button to an anchor tag or a div or anything else, or I can one-off style this button and not worry about duplicating the component or introducing some mad prop handling, and if I want to introduce a new dialog, I can just copy-paste the button and change it's `data-dialog-id`  to the new dialogs `id` attribute value.

Compare that, however, with the following react example:

```haml
= react_component "open-dialog-button", dialog_id: "bulk-delete"
= react_component "bulk-delete-dialog", id: "bulk-delete"
```

You can restructure this in to a variety of different patterns, from a single reusable `button` component that takes in a million props, to special one off ones or more generic ones such as this 'open-dialog-button' that I chose, but at the end of the day you are severly limited by the capabilities of [react-rails](https://github.com/reactjs/react-rails) and the interopt between Rails and JS land. If you want to one-off style this trigger different you have to duplicate the whole thing, introducing this one off react component and file and increasing your bundle size. Sure, you can have a generic `<Button>` component and reusable utils for everything, but in my opinion, the ergonomics of this are terrible for a project like tB.

```
testing unhighlighted with a really long line; the quick brown fox jumped over the lazy red cow and ran into chief
```

Vue and React are neat and powerful tools but they could be seen as heavy handed or require more JS-centric knowledge than you want to deal with. They also require. Stimulus could be seen as a wrapper around jQuery/JavaScript DOM APIs that handles a lot of the magic for you, and with all three of these solutions

{% highlight ruby %}
def test
  do_something()
end
{% endhighlight %}
