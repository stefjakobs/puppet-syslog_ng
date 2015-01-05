# add a file as source to syslog-ng, let it parse the input from that file
# and construct a new log message
define syslog_ng::parse_file (
  $files,
  $priority                = '51',
  $files_program_override  = '',
  $files_flags             = 'no-parse',
  $default_facility        = 'local0',
  $default_priority        = 'notice',
  $parser_enable           = false,
  $parser_columns          = '',
  $parser_delimiters       = ' ',
  $parser_flags            = 'greedy',
  $rewrite_enable          = false,
  $rewrite_set             = '',
  $parse_file_template     = 'syslog_ng/parse_files.conf.erb',
) {
  if $default_facility !~ /^(local[0-7]|auth|auth-priv|cron|daemon|ftp|kern|lpr|mail|mark|news|syslog|user|uucp)$/ {
    fail("default_facility = ${default_facility} is not supported")
  }
  if $default_priority !~ /^(debug|info|notice|warn|err|crit|alert|emerg)$/ {
    fail("default_priority = ${default_priority} is not supported")
  }
  ## TODO: check $files_flags in (empty-lines|kernel|no-multi-line|no-parse|store-legacy-msghdr|syslog-protocol|validate-utf8)

  if $parser_enable !~ /^(true|false)$/ {
    fail('parser_enable is a boolean flag')
  }
  if $rewrite_enable !~ /^(true|false)$/ {
    fail('rewrite_enable is a boolean flag')
  }
  ## TODO: check $parser_flags in (drop-invalid|escape-none, escape-backslash, escape-double-char, greedy, strip-whitespace)

  file { "/etc/syslog-ng/conf.d/${priority}-${name}.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'log',
    mode    => '440',
    content => template($parse_file_template),
    require => Class['syslog_ng::install'],
    notify  => Class['syslog_ng::service'],
  }
}

# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
