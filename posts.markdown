---
title: Posts
permalink: "/posts/"
---
<!-- Thanks Rob -->
{% capture post_years %}
  {% for post in site.posts %}
  {{ post.date | date: '%Y' }}
  {% endfor %}
{% endcapture %}

{% assign unique_post_years = post_years | split: " " | sort | uniq | reverse %}

### By Year

<p>
  {% for year in unique_post_years %}
    <a href="/{{year}}">{{year}}</a>
    {% if forloop.last != true %}
    &middot;
    {% endif %}
  {% endfor %}
</p>

[By Tag](/tags)

#### All Posts

<div class="flex flex-col space-y-8">
  {% for post in site.posts %}
    {% include post_block.html %}
  {% endfor %}
</div>
