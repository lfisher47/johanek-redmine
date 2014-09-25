# Class redmine::config
class redmine::config {

#  require 'apache'
  include ::apache

  class { 'apache::mod::passenger':
    passenger_root => '/opt/rh/ruby193/root/usr/share/gems/gems/passenger-4.0.18/lib/phusion_passenger/locations.ini',
    passenger_ruby => '/usr/bin/ruby193-ruby',
    mod_package    => 'mod_passenger',
    mod_package_ensure => '4.0.18-9.5.el6', 
  }

  File {
    owner => $redmine::params::apache_user,
    group => $redmine::params::apache_group,
    mode  => '0644'
  }

  file { $redmine::webroot:
    ensure => link,
    target => "/usr/src/redmine-${redmine::version}"
  }

  Exec {
    cmd => "/bin/chown -R ${redmine::params::apache_user}.${redmine::params::apache_group} /usr/src/redmine-${redmine::version}"
  }

  file { "${redmine::webroot}/config/database.yml":
    ensure  => present,
    content => template('redmine/database.yml.erb'),
    require => File[$redmine::webroot]
  }

  file { "${redmine::webroot}/config/configuration.yml":
    ensure  => present,
    content => template('redmine/configuration.yml.erb'),
    require => File[$redmine::webroot]
  }

  file { "${redmine::webroot}/Gemfile":
    ensure  => 'present',
    source  => 'puppet:///modules/redmine/Gemfile',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  apache::vhost { 'redmine':
    port          => '443',
    ssl           => true,
    docroot       => "${redmine::webroot}/public",
    servername    => $::fqdn,
    serveraliases => $redmine::vhost_aliases,
    options       => 'Indexes FollowSymlinks ExecCGI',
    directories   => [{ path              => "${redmine::webroot}/public/",
                            passenger_enabled => 'On'} ],
  }

  # Log rotation
  file { '/etc/logrotate.d/redmine':
    ensure => present,
    source => 'puppet:///modules/redmine/redmine-logrotate',
    owner  => 'root',
    group  => 'root'
  }

}
