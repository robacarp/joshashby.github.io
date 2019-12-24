---
title: Posts
layout: default
permalink: "/posts/"
---

#### Posts

<ul>
  {% for post in site.posts %}
    <li>
      <time datetime="{{ post.date | date: "%F" }}">{{ post.date | date: "%Y-%h-%d" }}</time>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
