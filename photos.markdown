---
title: Photos
layout: default
permalink: "/photos/"


images:
  - "_photos/couch_chief.jpg"
  - "_photos/kitchen_chief.jpg"
  - "_photos/cabin_stars.jpg"
---

Some times I take photos, and in rarer times some of those might end up here. Interested
in my [gear?](/photo-gear/)

---

{% for photo in page.images %}
  {% picture {{photo}} %}
{% endfor %}
