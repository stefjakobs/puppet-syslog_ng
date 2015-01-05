# logrotate configuration
class logrotate::config {
  include logrotate::params

  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => Class['logrotate::install'],
  }

  file {
    '/etc/logrotate.d/':
      ensure  => directory,
      mode    => '0755';
    '/etc/logrotate.d/by-puppet.d':
      ensure  => directory,
      mode    => '0755',
      recurse => true,
      purge   => true;
    '/etc/logrotate.d/by-puppet.conf':
      ensure  => present,
      content => 'include /etc/logrotate.d/by-puppet.d';

    ## make sure logrotate runs at midnight
    '/etc/cron.daily/logrotate':
      ensure  => absent;

    '/etc/cron.d/logrotate':
      source  => 'puppet:///modules/logrotate/logrotate.cron';

    '/usr/local/sbin/run-logrotate.sh':
      mode    => '0755',
      source  => "puppet:///modules/logrotate/${logrotate::params::run_logrotate_script}";
  }
}
