# == Class: dropbear
#
# Install and configure dropbear using puppet.
#
# === Parameters
#
# [*no_start*]
#   Integer (0|1) used to prevent dropbear start.
#   Default: 0
#
# [*port*]
#   Integer, dropbear listen port
#   Default: 22
#
# [*extra_args*]
#   Extra argument passed to dropbear deamon (see man)
#   Default: nil
#
# [*banner*]
#   Display the contents of the file banner before user login.
#   Default: nil
#
# [*receive_window*]
#   Specify the per-channel receive window buffer size.
#   Increasing this may improve network performance at the expense of memory use.
#   Use -h to see the default buffer size.
#   Default: 65536
#
# === Variables
#
# [*package_name*]
#   Dropbear package name.
#
# [*service_name*]
#   Dropbear service name.
#
# [*rsakey*]
#   Use the contents of the file rsakey for the rsa host key
#   (default: /etc/dropbear/dropbear_rsa_host_key).
#   This file is generated with dropbearkey
#
# [*dsskey*]
#   Use the contents of the file dsskey for the DSS host key
#   (default: /etc/dropbear/dropbear_dss_host_key).
#   Note that some SSH implementations use the term "DSA" rather than "DSS",
#   they mean the same thing. This file is generated with dropbearkey.
#
# [*cfg_file*]
#   Location of configuration file.
#
# [*cfg_template*]
#   Location of configuration template.
#
#
# === Examples
#
#  include 'dropbear'
#
#   or
#
#  class {
#    'dropbear':
#      port            => '443',
#      extra_args      => '-s',
#      banner          => '/etc/banner',
#  }
#
# === Authors
#
# Kyle Anderson <kyle@xkyle.com>
# Sebastien Badia <seb@sebian.fr>
#
# === Copyright
#
# Copyleft 2013 Sebastien Badia.
# See LICENSE file.
#
class dropbear (
  String[1] $package_name                               = $dropbear::params::package_name,
  String[1] $service_name                               = $dropbear::params::service_name,
  Variant[Integer[0,1], Enum['0', '1']] $no_start       = '0',
  Variant[Stdlib::Port, Pattern[/^\d+$/]] $port         = '22',
  $extra_args                                           = '',
  $banner                                               = '',
  Stdlib::Absolutepath $rsakey                          = $dropbear::params::rsakey,
  Stdlib::Absolutepath $dsskey                          = $dropbear::params::dsskey,
  Stdlib::Absolutepath $cfg_file                        = $dropbear::params::cfg_file,
  $cfg_template                                         = $dropbear::params::cfg_template,
  Variant[Integer[0], Pattern[/^\d+$/]] $receive_window = '65536'
) inherits dropbear::params {

  package {
    $package_name:
      ensure => installed;
  }

  service {
    $service_name:
      ensure     => running,
      hasrestart => true,
      hasstatus  => false,
      require    => Package[$package_name];
  }

  file {
    $cfg_file:
      ensure  => file,
      content => template($cfg_template),
      owner   => root,
      group   => root,
      mode    => '0444',
      notify  => Service[$service_name],
      require => Package[$package_name];
  }

} # Class:: dropbear
