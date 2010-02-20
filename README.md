Paper Trail
===========

Paper Trail is a single-user publishing tool for book reviews. It's written in
[Ruby on Rails][1]; content should be formatted using [Markdown][2]. Paper
Trail is written by [Benedict Eastaugh][3] and licensed under the GPL.


Dependencies
------------

Paper Trail is compatible with Rails 3. As well as the usual Rails
dependencies, Paper Trail requires the following Gems:

* [RDiscount][4], a Ruby wrapper around a C implementation of [Markdown][3]
  and [SmartyPants][5].
* [`will_paginate`][6]
* [URLify][7]
* [Jake][10]
* [REST Client][11]
* [Nokogiri][12]
* [JSON for Ruby][13]


Configuration
-------------

Like all Rails applications, Paper Trail needs a [database.yml][8] file with
the relevant configuration details to be added to the `config` directory. In
addition to this, an environment-specific configuration file named
`papertrail.yml` can be added to the `config` directory to add some simple
customisations to the application. Here's a sample configuration block for a
development environment.

    development:
      title: Books on Extralogical
      author: Benedict Eastaugh
      blurb: |
              This piece of text will be formatted with Markdown and displayed
              at the bottom of every page on the site.
      perform_authentication: true
      isbndb_api_key: ABCDEFGH


Licence
-------

Paper Trail is free software, released under the GNU General Public License
Version 2. Please refer to the LICENSE file that should have been distributed
with this software for details. If you have not received a copy of the license,
you can [get a copy][9] from the Free Software Foundation.


[1]:  http://rubyonrails.org/
[2]:  http://daringfireball.net/projects/markdown/
[3]:  http://extralogical.net/
[4]:  http://github.com/rtomayko/rdiscount/
[5]:  http://daringfireball.net/projects/smartypants/
[6]:  http://github.com/mislav/will_paginate/
[7]:  http://github.com/ionfish/urlify/
[8]:  http://wiki.rubyonrails.org/rails/pages/database.yml
[9]:  http://www.fsf.org/licensing/licenses/info/GPLv2.html
[10]: http://github.com/jcoglan/jake/
[11]: http://rdoc.info/projects/archiloque/rest-client
[12]: http://nokogiri.org/
[13]: http://flori.github.com/json
