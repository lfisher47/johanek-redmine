class redmine::postgresql {
  $dbname = $redmine::db_database ? {
    'UNSET' => 'redmine',
    default => $redmine::db_database,
  }

  $password = $redmine::database_password ? {
    'UNSET' => false,
    default => postgresql_password($redmine::database_user, $redmine::database_password),
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server
  postgresql::server::db { $dbname:
    user     => $redmine::database_user,
    password => $password,
    owner    => $redmine::database_user,
  }

  Postgresql::Server::Role[$redmine::database_user] -> Postgresql::Server::Database[$dbname]
}



