## include to have a working logrotate configuration
class logrotate {
  include logrotate::install, logrotate::config
}
