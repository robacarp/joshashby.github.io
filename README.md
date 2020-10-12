This repo contains the Jekyll setup for my personal site.

## Getting Started
- To dev: `bin/dev-server`
  - http://localhost:4000
  - http://http://localhost:4000/admin/
- To build: `bundle exec jekyll build`

The site is built on Github Actions and deployed to Github Page using a setup
similar to that described [here, by David Stosik](https://davidstosik.github.io/2020/05/31/static-blog-jekyll-410-github-pages-actions.html).

### Devops

There is a Pulumi setup for managing the DNS records and any other
infrastructure such as the CDN for the photography page in `devops/`.

### Styling
Postcss and tailwindcss are available to provide styling.

### Utils
jekyll-admin provides a nice web based authoring interface for new content.

### Photography Page

The workflow for the photography page is still a work in progress and I try to
figure out the best way to make it scale with my somewhat iPad/mobile based
workflow. It's modeled after [Brandur's setup](https://github.com/brandur/sorg/blob/cbd52b385f8962be49ee52e8d15a05efb1c7783a/docs/photographs.md) but with some changes such as
not being backed by dropbox.

Photos are all stripped of EXIF, recompressed using some imagemagick parameters
I found on SO and resized to: 400px, 600px, 800px, 1000px and 2000px variants.
These are then uploaded to a DO Space/S3 Bucket which is configured to be a
CDN.

Currently it consists of two little bash scripts and a Jekyll data file:

`photify` which takes in a name, without extension (odd i know), for a file in
`_raw_photos` and resizes, strips exif and recompresses it to 400, 600, 800,
1000, and 2000 pixels wide and writes the scaled images out to `photos/`.

`upload-photos` does what it says on the tin. It uploads the processed photos
up to the CDN Bucket.

`_data/photography.yml` contains the CDN url (Makes for easy testing, switch it
to `"/photos"` for local testing, for example) and an array of the photographs
with the title, description and name "slug" (without the extension). The url
could probably be a config for the whole site eventually but meh, I'll get to
that later.

Jekyll renders an image tag with a `srcset` for better performance for each
entry in the data file, using the name and the cdn root url.

It's not foolproof at the moment and it does require my laptop, but eventually
I'd like to have a secondary bucket, or other private storage area, that the
Github Action can access and have it pull down and process any new photos found
by diffing whats there with the list in the data file. Since I haven't found a
good iOS/iPadOS S3 file uploading app or Scriptable setup, this second part is
on hold until I figure out a better way to handle this.
