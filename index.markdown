---
title: Home of Ashby
---

# Hello!

I'm [Ashby](/about/), a [software dev](https://github.com/JoshAshby) but occasionally I [take photos](/photos/) or worse [write](/posts/).

Looking to get a hold of me?
 - Shoot me an email at `me (at) joshashby.com`
 - Find me on the [libera irc network](https://libera.chat/) as `JoshAshby`
 - Ping me on <a rel="me" href="https://octodon.social/@ashby">Mastodon</a> as `@ashby@octodon.social`

<hr />

#### Recent Posts

<div class="flex flex-col space-y-8">
  {% for post in site.posts limit: 5 %}
    <div class="flex flex-col space-y-1">
      <div class="flex flex-row space-x-2 items-baseline">
        <time datetime="{{ post.date | date: "%F" }}" class="font-mono text-sm">{{ post.date | date: "%Y-%h-%d" }}</time>
        <a href="{{ post.url }}">{{ post.title }}</a>
      </div>
      <div class="flex flex-row space-x-1">
        {% for tag in post.tags %}
          <a href="/tags/#{{ tag | slugify }}" name="{{ tag }}"><span class="tag">{{ tag }}</span></a>
        {% endfor %}
      </div>
    </div>
  {% endfor %}
</div>
