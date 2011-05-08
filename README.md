Paper Trail
===========

Paper Trail is a single-user publishing tool for book reviews. It's written in
[Ruby on Rails][rails]; content should be formatted using [Markdown][md]. Paper
Trail is written by [Benedict Eastaugh][ben] and licensed under the GPL.


Configuration
-------------

Like all Rails applications, Paper Trail needs a `database.yml` file with
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
Version 2. Please refer to the `LICENSE` file that should have been distributed
with this software for details. If you have not received a copy of the license,
you can [get a copy][gpl] from the Free Software Foundation.


  [rails]: http://rubyonrails.org/
  [md]:    http://daringfireball.net/projects/markdown/
  [ben]:   http://extralogical.net/
  [gpl]:   http://www.fsf.org/licensing/licenses/info/GPLv2.html
