This repo contains the Jekyll setup for my personal site.

- To dev: `bin/dev-server`
  - http://localhost:4000
  - http://http://localhost:4000/admin/
- To build: `bundle exec jekyll build`

The site is built on Github Actions and deployed to Github Page using a setup
similar to that described [here, by David Stosik](https://davidstosik.github.io/2020/05/31/static-blog-jekyll-410-github-pages-actions.html).

There is a Pulumi setup for managing the DNS records in `devops/`.

Postcss and tailwindcss are available to provide styling, and jekyll-admin
provides a nice web based authoring interface for new content.
