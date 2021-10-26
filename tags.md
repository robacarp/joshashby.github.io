---
title: Posts by Tag
---

### Posts by Tag

<!-- Thanks Rob, too -->
{% capture tag_words %}
  {% for tag in site.tags %}
    {{ tag | first | downcase }}
    {% unless forloop.last %}
    ::
    {% endunless %}
  {% endfor %}
{% endcapture %}

{% assign sorted_tags = tag_words | split: " " | join: "" | split: "::" | sort %}

{% for i in (0..site.tags.size) %}
  {% assign tag = sorted_tags[i] | strip_whitespace %}
  {% assign posts = site.tags[tag] %}

  <a href="#{{ tag | slugify }}" name="{{ tag }}" class="text-xl">{{ tag }}</a>

  <div class="flex flex-col space-y-8">
    {% for post in posts %}
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

  <hr />
{% endfor %}
