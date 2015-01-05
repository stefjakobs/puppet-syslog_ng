# syslog-ng parameters
class syslog_ng::params {
  case ($::operatingsystem) {
    /(opensuse|SLES)/: {
      $syslog_ng_conf_template = 'syslog_ng/syslog-ng.conf.suse.erb'
      $syslog_ng_service       = 'syslog'
    }
    /(Ubuntu|Debian)/: {
      $syslog_ng_conf_template = 'syslog_ng/syslog-ng.conf.erb'
      $syslog_ng_service       = 'syslog-ng'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
