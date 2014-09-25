class redmine::install {

  $install = "redmine::install::${::redmine::install_type}"

  class { $install: }

}
