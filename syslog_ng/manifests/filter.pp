## define a additional filter (and source and destination)
## which will be places in /etc/syslog-ng/conf.d/.
## this adds also the needed logrotate file.
##
## WARNING:
## * if $is_template is false, then $content_template must be used.
define syslog_ng::filter (
  $log_dir                = $name,
  $priority               = '50',
  $is_template            = true,
  $content_template       = "syslog_ng/${priority}${name}.conf.erb",
  $rotate_files           = '',
  $rotate_olddir          = 'alt',
  $rotate_notifempty      = true,
  $block                  = '',
  $block_priority         = '15',
  $block_content_template = "syslog_ng/${priority}${name}.conf.erb",
  $block_is_template      = true,
  $base_dir               = '/var/log/',
  $is_server             = false,
) {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '644',
  }

  if ($priority !~ /^\d+$/) {
    fail("${module_name}: priority must be a number")
  }
  if ($block_priority !~ /^\d+$/) {
    fail("${module_name}: block_priority must be a number")
  }

  if ($rotate_notifempty != true and $rotate_notifempty != false) {
    fail("${module_name}: rotate_olddir must be true or false")
  }

  if ($is_template == true) {
    file {"/etc/syslog-ng/conf.d/${priority}${name}.conf":
      content => template($content_template);
    }
  } elsif ($is_template == false) {
    file {"/etc/syslog-ng/conf.d/${priority}${name}.conf":
      source => "puppet:///modules/${content_template}";
    }
  } else {
    fail("${module_name}: is_template must be true or false")
  }

  if ($block != '') {
    if ($block_is_template == true) {
      file {"/etc/syslog-ng/conf.d/${block_priority}${block}.conf":
        content => template($block_content_template);
      }
    } elsif ($block_is_template == false) {
      file {"/etc/syslog-ng/conf.d/${block_priority}${block}.conf":
        source => "puppet:///modules/${block_content_template}";
      }
    } else {
      fail("${module_name}: block_is_template must be true or false")
    }
  }

  ## if host is syslog_ng server then add $log_dir dir and $log_dir/alt dir
  if ($is_server == true) {
    $local_base_dir = $syslog_ng::server::base_dir
    file {
      [ "${local_base_dir}/${log_dir}",
        "${local_base_dir}/${log_dir}/alt",
      ]:
        ensure => directory,
        group  => $syslog_ng::server::base_group,
        mode   => '0750';
    }
  } elsif ($is_server == false) {
    $local_base_dir = $base_dir
    # FIXME: soll "${local_base_dir}/${log_dir}" erstellt werden?
  } else {
    fail("${module_name}: is_server must be true or false")
  }

  ## FIXME: Hier könnten noch mehr Optionen an logrotate::set
  ## durchgeschleift werden. Wahrscheinlich gehört dies aber hier
  ## aber gar nicht hin sondern in einen eigenen Rollen-Klasse.
  if ($rotate_files != '') {
    logrotate::set { $name:
      rotate_files => $rotate_files,
      notifempty   => $rotate_notifempty,
      olddir       => $rotate_olddir;
    }
  }
}
