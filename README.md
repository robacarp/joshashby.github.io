This repo contains the Jekyll setup for my personal site.

- To dev: `bin/dev-server`
  - http://localhost:4000
  - http://http://localhost:4000/admin/
- To build: `bundle exec jekyll build`
- To deploy: `bin/deploy`

The site is deployed to an S3 bucket setup to host a static site. `bin/deploy`
will handling uploading the built site, and also a backup tar.gz of the current
site to `/deploys/deploy-<current date>.tar.gz`.

Postcss and tailwindcss are available to provide styling, and jekyll-admin
provides a nice web based authoring interface for new content.
