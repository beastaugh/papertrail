Paper Trail
===========


Paper Trail is a single-user publishing tool for book reviews. It's written in [Ruby on Rails](http://rubyonrails.org/); content should be formatted using [Markdown](http://daringfireball.net/projects/markdown/). Paper Trail is written by [Benedict Eastaugh](http://extralogical.net/) and licensed under the GPL.


Dependencies
------------

As well as the usual Rails dependencies, Paper Trail requires the following Gems:

* [BlueCloth](http://deveiate.org/projects/BlueCloth) is a Ruby implementation of Markdown.
* [RubyPants](http://chneukirchen.org/blog/static/projects/rubypants.html) is a Ruby port of [SmartyPants](http://daringfireball.net/projects/smartypants/).


Configuration
-------------

Like all Rails applications, Paper Trail needs a [database.yml](http://wiki.rubyonrails.org/rails/pages/database.yml) file with the relevant configuration details to be added to the config/ directory. In addition to this, an environment-specific configuration file named papertrail.yml can be added to the config/ directory to add some simple customisations to the application. Here's a sample configuration block for a development environment.

    development:
      title: Books on Extralogical
      author: Benedict Eastaugh
      blurb: |
              This piece of text will be formatted with Markdown and displayed at the bottom of every page on the site.
      perform_authentication: true
      password: J9BtR68NEq75yM24


Licence
-------

Paper Trail is free software, released under the GNU General Public License Version 2. Please refer to the LICENSE file that should have been distributed with this software for details. If you have not received a copy of the license, you can [get a copy](http://www.fsf.org/licensing/licenses/info/GPLv2.html) from the Free Software Foundation.