# == Class: itemsapi
#
# Full description of class itemsapi here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'itemsapi':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
define itemsapi (
  $ensure,
)
  {
    validate_re($ensure, ['present','absent'])
    if $ensure=='present' {
      exec { 'create item' :
        command => "/usr/bin/curl -H 'Content-Length: 0' -fIX PUT http://localhost:4567/items/${name}",
        unless  => "/usr/bin/curl -fIX GET http://localhost:4567/items/${name}",
      }
    }
    elsif $ensure=='absent' {
      exec { 'delete item' :
        command => "/usr/bin/curl -fIX DELETE http://localhost:4567/items/${name}",
        onlyif  => "/usr/bin/curl -fIX GET http://localhost:4567/items/${name}",
      }
    } else {
      fail('ensure parameter must be present or absent')
    }
  }
