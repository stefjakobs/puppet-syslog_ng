# logrotate parameters
class logrotate::params {
  case ($::operatingsystem) {
    /(opensuse|SLES)/: {
      $run_logrotate_script    = 'run-logrotate.sh.suse'
      $postrotate_script       = '/etc/init.d/syslog reload > /dev/null'
    }
    /(Ubuntu|Debian)/: {
      $run_logrotate_script    = 'run-logrotate.sh.ubuntu'
      $postrotate_script       = 'invoke-rc.d syslog-ng reload > /dev/null'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
