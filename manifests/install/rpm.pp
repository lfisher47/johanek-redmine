class redmine::install::rpm {

  $rpms = [ 'ruby193-rubygem-rails', 'ruby193-rubygem-jquery-rails', 'ruby193-rubygem-coderay', 'ruby193-rubygem-fastercsv', 'ruby193-rubygem-awesome_nested_set', 'ruby193-rubygem-net-ldap', 'ruby193-rubygem-redcarpet', 'ruby193-rubygem-pg', 'redmine', 'ruby193-rubygem-bundler', 'ruby193-rubygem-ruby-openid', 'ruby193-rubygem-rack-openid', 'ruby193-ruby-wrapper' ] 

  ensure_packages($rpms)

  package { 'ruby193-rubygem-rake':
    ensure => '10.1.1-8.el6',
  }

  package { 'ruby193-rubygem-i18n':
    ensure => 'latest',
  }

  package { 'ruby193-mod_passenger40':
    ensure => 'installed',
  }
  

}
