# install logrotate
class logrotate::install {
  package { 'logrotate':
    ensure  => present,
  }
}
