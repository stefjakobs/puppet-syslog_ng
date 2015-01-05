# run syslog-ng as logserver
class syslog_ng::server (
  $src_name   = [ 's_network' ],
  $port       = [ '514' ],
  $ip_addr    = [ 'UNSET' ],
  $base_dir   = '/srv/log/mail',
  $base_group = 'logmail',
) {

  File {
    ensure    => present,
    owner     => 'root',
    group     => 'root',
    mode      => '0444',
    require   => Class[syslog_ng],
    notify    => Class[syslog_ng::service],
  }

  file {
    $base_dir:
      ensure => directory,
      group  => $base_group,
      mode   => '0755';

    '/etc/syslog-ng/conf.d/10globalfilter.conf':
      content => template('syslog_ng/10globalfilter.conf.erb');

    '/etc/syslog-ng/conf.d/10sources.conf':
      content => template('syslog_ng/10sources.conf.erb');

    '/etc/syslog-ng/conf.d/90fallback.conf':
      content => template('syslog_ng/90fallback.conf.erb');
  }

  logrotate::set {
    'fallback-logsrv':
      rotate_files => "${base_dir}/fallback",
      notifempty   => true;
  }

}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
