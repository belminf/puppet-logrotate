class logrotate::base {
    package { 'logrotate':
        ensure => latest,
    }

    file { '/etc/logrotate.d':
        ensure => directory,
        mode => 0755,
        owner => 'root',
        group => 'root',
        require => Package['logrotate'],
    }
}

# SELinux considerations: https://access.redhat.com/solutions/39006
# 
# $ semanage fcontext -a -t var_log_t '/backup/mysql(/.*)?'
# $ restorecon -Frvv /backup/mysql

define logrotate::rule(
    $log_path,
    $condition = 'weekly',
    $keep_count  = 4,
    $compress = true,
    $create_mode = 0600,
    $create_owner = 'root',
    $create_group = 'root',
	$dateext = true,
    $ifempty  = false,
    $missingok  = true,
    $sharedscripts  = true,
    $postrotate = undef,
    $prerotate = undef,
) {
    include 'logrotate::base'

    file { "/etc/logrotate.d/${name}":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => template('logrotate/rule.erb'),
      }

}
