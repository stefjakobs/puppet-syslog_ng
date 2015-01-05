# everything that is needed to have a working syslog-ng service
class syslog_ng (
  $dest_server             = 'log.example.com',
  $dest_port               = '514',
  $dest_proto              = 'udp',
  $version                 = '3.3',
  $default_owner           = 'root',
  $default_group           = 'adm',
  $default_perm            = '0640',
  $default_stats_freq      = '3600',
  $default_chain_hostnames = 'off',
  $default_flush_lines     = '0',
  $default_use_dns         = 'yes',
  $default_use_fqdn        = 'no',
  $all_to_dest_server      = 'no',
) {
  class { 'syslog_ng::config':
    dest_server             => $syslog_ng::dest_server,
    dest_port               => $syslog_ng::dest_port,
    dest_proto              => $syslog_ng::dest_proto,
    version                 => $syslog_ng::version,
    default_owner           => $syslog_ng::default_owner,
    default_group           => $syslog_ng::default_group,
    default_perm            => $syslog_ng::default_perm,
    default_stats_freq      => $syslog_ng::default_stats_freq,
    default_chain_hostnames => $syslog_ng::default_chain_hostnames,
    default_flush_lines     => $syslog_ng::default_flush_lines,
    default_use_dns         => $syslog_ng::default_use_dns,
    default_use_fqdn        => $syslog_ng::default_use_fqdn,
    all_to_dest_server      => $syslog_ng::all_to_dest_server,
  }
  include syslog_ng::install, syslog_ng::service
  include syslog_ng::service::enabled
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
