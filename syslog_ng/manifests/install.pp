# install syslog-ng
class syslog_ng::install {
  rus::package {
    'syslog-ng':
      ensure => present;
    'rsyslog':
      ensure => $::operatingsystem ? {
        /(Ubuntu|Debian)/ => purged,
        default           => absent,
      }
  }
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
