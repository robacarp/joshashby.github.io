---
title: Welcome to Jekyll!
layout: post
date: '2019-10-07 22:40:57'
tags: test, home
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

Jekyll requires blog post files to be named according to the following format:

`YEAR-MONTH-DAY-title.MARKUP`

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit numbers, and `MARKUP` is the file extension representing the format used in the file. After that, include the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].


[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/

- one
- two
- three


```ruby
def thing *args
   puts args.to_s
end
```

# H1
##  H2
###  H3
####  H4
#####  H5
######  H6

*itallics*

**boooooold**

> someonce said something smart enough for this tag


1. numbers
2. fish
3. red
4. blue

![](/avatar.jpg)


{% source ruby location="https://github.com/seattlerb/minitest/blob/1f2b1328f286967926a381d7a34e0eadead0722d/lib/minitest.rb#L52-L66" 
               hl_lines="1 2 3 4 13 14 15" %}
def self.autorun
  at_exit {
    next if $! and not ($!.kind_of? SystemExit and $!.success?)

    exit_code = nil

    at_exit {
      @@after_run.reverse_each(&:call)
      exit exit_code || false
    }

    exit_code = Minitest.run ARGV
  } unless @@installed_at_exit
  @@installed_at_exit = true
end
{% endsource %}




{% source haml hl_lines="1 4" %}
%button( data-behavior="open-dialog", data-dialog-id="bulk-delete" )
  Bulk Delete

%dialog#bulk-delete
  %header
    -# Dialog title and a close button could be here
  %section.dialog-main
    -# A table of records or some confirmation message might live here
  %footer
    -# Some actions as buttons or links could be here
{% endsource %}

{% highlight haml linenos %}
%button( data-behavior="open-dialog", data-dialog-id="bulk-delete" )
  Bulk Delete

%dialog#bulk-delete
  %header
    -# Dialog title and a close button could be here
  %section.dialog-main
    -# A table of records or some confirmation message might live here
  %footer
    -# Some actions as buttons or links could be here
{% endhighlight %}
