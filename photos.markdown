---
title: Photos
layout: default
permalink: "/photos/"
---

Some times I take photographs, and in rarer times some of those might end up here. Interested
in my [gear?](/photo-gear/)

---

{% for photo in site.data.photographs.photographs %}
<img src="{{site.data.photographs.cdn}}/{{photo.slug}}-800.jpg" srcset="{{site.data.photographs.cdn}}/{{photo.slug}}-400.jpg 400w, {{site.data.photographs.cdn}}/{{photo.slug}}-600.jpg 600w, {{site.data.photographs.cdn}}/{{photo.slug}}-800.jpg 800w, {{site.data.photographs.cdn}}/{{photo.slug}}-1000.jpg 1000w" />
{% endfor %}
