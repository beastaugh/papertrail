Paper Trail
===========


Paper Trail is a single-user publishing tool for book reviews. It's written in [Ruby on Rails](http://rubyonrails.org/); content should be formatted using [Markdown](http://daringfireball.net/projects/markdown/). Paper Trail is written by [Benedict Eastaugh](http://extralogical.net/) and licensed under the GPL.


Dependencies
------------

As well as the usual Rails dependencies, Paper Trail requires the following Gems:

* [RDiscount](http://github.com/rtomayko/rdiscount/) is a Ruby wrapper around a C implementation of [Markdown](http://daringfireball.net/projects/markdown/).
* [RubyPants](http://chneukirchen.org/blog/static/projects/rubypants.html) is a Ruby port of [SmartyPants](http://daringfireball.net/projects/smartypants/).

The following plugins are also needed:

* [will_paginate](http://github.com/mislav/will_paginate/)
* [acts_as_list](http://github.com/rails/acts_as_list/)

They are included as submodules in Paper Trail's Git repository. To install them when you first clone the repository, run these commands:

    git submodule init
    git submodule update

You can read more about using Git submodules to track Rails plugins in [this article](http://woss.name/2008/04/09/using-git-submodules-to-track-vendorrails/).


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
