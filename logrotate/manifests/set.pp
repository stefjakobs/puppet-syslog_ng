## add configuration file which causes some files to be rotated
define logrotate::set (
  $rotate_files,
  $ensure             = present,
  $compress           = true,
  $copytruncate       = true,
  $create_mode        = '',
  $create_owner       = '',
  $create_group       = '',
  # possible values: daily, weekly, monthly, yearly
  $interval           = 'daily',
  $dateext            = true,
  $dateformat         = '',
  $dateyesterday      = false,
  $delaycompress      = true,
  $maxage             = '',
  $maxsize            = '',
  $minsize            = '',
  $missingok          = true,
  # ifempty is the default
  $notifempty         = false,
  $olddir             = '',
  # set to '' to disable postrotate scripts
  $postrotate_scripts = false,
  $rotate             = '7',
  $size               = '',
) {
  include logrotate, logrotate::params

  # set defaults:
  if ($postrotate_scripts != false) {
    $p_scripts = $postrotate_scripts
  } else {
    $p_scripts = $logrotate::params::postrotate_script
  }

  file { "/etc/logrotate.d/by-puppet.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('logrotate/config_file.erb'),
  }
}
