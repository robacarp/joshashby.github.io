---
title: Photos
layout: default
permalink: "/photos/"
---

Some times I take photographs, and in rarer times some of the better ones might end up here. Interested in my [gear?](/photo-gear/)

You can find more of my photos on [my flickr](https://www.flickr.com/photos/joshashby/) {% aside page. %}It's not well maintained by me at the moment, lagging behind by a few years, but it's got a lot of my earlier history.{% endaside %}

{: .callout.blue}
Most of these are of a ridiculously cute little dog named Chief. You've been
warned :)

<hr/>

{%for photo in site.data.photographs.photographs %}
<figure>
<img src="{{site.data.photographs.cdn}}/{{photo.slug}}-800.jpg" srcset="{{site.data.photographs.cdn}}/{{photo.slug}}-400.jpg 400w, {{site.data.photographs.cdn}}/{{photo.slug}}-600.jpg 600w, {{site.data.photographs.cdn}}/{{photo.slug}}-800.jpg 800w, {{site.data.photographs.cdn}}/{{photo.slug}}-1000.jpg 1000w" alt="{{photo.title}}"/>
{% if photo.description %}
<figcaption>{{photo.description}}</figcaption>
{% endif %}
</figure>
{% endfor %}
