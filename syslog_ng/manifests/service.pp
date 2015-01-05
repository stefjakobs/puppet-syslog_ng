# syslog-ng service
class syslog_ng::service {
  include syslog_ng::params

  service { $syslog_ng::params::syslog_ng_service:
    hasstatus  => true,
    hasrestart => true,
    require    => Class['syslog_ng::config'],
  }
}

# syslog-ng service enabled
class syslog_ng::service::enabled inherits syslog_ng::service {
  Service[$syslog_ng::params::syslog_ng_service] { ensure => running, enable => true }
}

# syslog-ng service disabled
class syslog_ng::service::disabled inherits syslog_ng::service {
  Service[$syslog_ng::params::syslog_ng_service] { ensure => stopped, enable => false }
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
