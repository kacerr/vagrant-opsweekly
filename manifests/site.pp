# get rid of deprecation warning for virtual packages settings
Package {
    allow_virtual => true,
}

# necesseary packages
package { 'httpd': ensure => 'installed'}
package { 'php': ensure => 'installed'}
package { 'php-mysql': ensure => 'installed'}
package { 'git': ensure => 'installed'}
package { 'mariadb-server': ensure => 'installed'}
package { 'mariadb': ensure => 'installed'}

# ensure that services are running
service { 'httpd': ensure   => running, enable => true, require => Package['httpd'] }
service { 'mariadb': ensure => running, enable => true, require => Package['mariadb-server'] }

# for local usage this is not security risk
# in publicly available environment configure firewall propery
service { 'firewalld': ensure => stopped, enable => false }

# prepare directory structure
file { '/srv/www': ensure => 'directory' }

# clone opsweekly up from git if it does not already exist
exec { 'git_clone_opsweekly':
  command => '/usr/bin/git clone https://github.com/etsy/opsweekly.git /srv/www/opsweekly',
  onlyif  => '/usr/bin/test ! -d /srv/www/opsweekly',
  require => File['/srv/www'],
}

# initialize opsweekly database unless it already exists
exec { 'initialize_opsweekly_database':
  command => '/bin/bash /vagrant/files/init-opsweekly-database.sh',
  unless  => '/bin/mysqlshow | /bin/grep -q "opsweekly"',
  require => Service['mariadb'],
}

# copy apache config file and restart if needed
file { '/etc/httpd/conf.d/001_opsweekly.conf':
  source  => '/vagrant/files/001_opsweekly.conf',
  notify  => Service["httpd"],
  require => Package["httpd"],
}

# copy opsweekly config files
file { '/srv/www/opsweekly/phplib/config.php':
  source  => '/vagrant/files/opsweekly_config.php',
  require => Exec['git_clone_opsweekly']
}
