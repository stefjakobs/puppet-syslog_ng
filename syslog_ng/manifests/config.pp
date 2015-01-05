# syslog-ng configuration files
class syslog_ng::config (
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
  include syslog_ng::params
  ## FIXME: File 20apache.conf needs params
  ##        20apache.conf is no longer shipped by this module.
  include apache2::params

  File {
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    require => Class['syslog_ng::install'],
    notify  => Class['syslog_ng::service'],
  }

  # options syntax check
  if ($version !~ /^[2-5]\.\d$/) {
     fail("${module_name}: version must be a version number (e.g. 3.3)")
  }
  if ($default_perm !~ /^[0-7][0-7][0-7][0-7]?$/) {
     fail("${module_name}: default_perm must be a three or four digit permission mode")
  }
  if ($default_stats_freq !~ /^\d+$/) {
     fail("${module_name}: default_stats_freq must be a number")
  }
  if ($default_chain_hostnames !~ /^on|off$/) {
     fail("${module_name}: default_chain_hostnames must be 'yes' or 'no'")
  }
  if ($default_flush_lines !~ /^\d+$/) {
     fail("${module_name}: default_flush_lines must be an number")
  }
  if ($default_use_dns !~ /^yes|no$/) {
     fail("${module_name}: default_use_dns must be 'yes' or 'no'")
  }
  if ($default_use_fqdn !~ /^yes|no$/) {
     fail("${module_name}: default_use_fqdn must be 'yes' or 'no'")
  }
  if ($all_to_dest_server !~ /^yes|no$/) {
     fail("${module_name}: all_to_dest_server must be 'yes' or 'no'")
  }

  file {
    '/etc/syslog-ng':
      ensure  => directory,
      mode    => '0755';

    '/etc/syslog-ng/syslog-ng.conf':
      content => template($syslog_ng::params::syslog_ng_conf_template);

    '/etc/syslog-ng/conf.d/':
      ensure  => directory,
      mode    => '0755',
      recurse => true,
      purge   => true;

    '/etc/syslog-ng/conf.d/AAA_MANAGED_BY_PUPPET':
      ensure  => present;

    '/etc/syslog-ng/conf.d/10destination.conf':
      content => template('syslog_ng/10destination.conf.erb');

    '/etc/syslog-ng/conf.d/00load-mongodb.conf':
      source  => 'puppet:///modules/syslog_ng/00load-mongodb.conf';

    '/etc/syslog-ng/conf.d/00load-sql.conf':
      source  => 'puppet:///modules/syslog_ng/00load-sql.conf';

    '/etc/syslog-ng/conf.d/00load-tfjson.conf':
      source  => 'puppet:///modules/syslog_ng/00load-tfjson.conf';
  }
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
