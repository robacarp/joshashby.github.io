---
title: Modeling Sequenced Keyboard Shortcuts
tags: []
---

{% include annotation_info.html %}



What's a tree do with a keyboard?
	
Every few projects I run into a situation where I want to have support for multi-key shortcuts similar to what one finds in Vim, ie: `gg` goes to the top of the file while `g$` goes to the end of the line. Today I'll cover one of the techniques I've used for building such a feature.
