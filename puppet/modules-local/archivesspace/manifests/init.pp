# == Class: archivesspace
#
# Full description of class archivesspace here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'archivesspace':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class archivesspace (
  $version = '1.4.1',
  $install_dir = '/opt/archivesspace',
  $install_type = 'prod',
  $branch = 'master'
) {
  #if $install_type == 'production' {
  #  puppi::netinstall { 'netinstall-archivesspace':
  #    url => "https://github.com/archivesspace/archivesspace/archive/master.zip",
  #    extracted_dir       => 'archivesspace',
  #    destination_dir     => '/tmp',
  #    #postextract_command => "mv -f /tmp/${extracted_dir} ${install_dir}",
  #    postextract_command => "mv -f /tmp/archivesspace ${install_dir}",
  #  }
  #}
  if $install_type == 'dev' {
    #vcsrepo { "${install_dir}/${repo}":
    vcsrepo { '/opt/archivesspace':
      ensure    => latest,
      owner     => 'root',
      group     => 'root',
      provider  => git,
      require   => [ Package [ 'git' ] ],
      #source    => 'git@github.com:/archivesspace/archivesspace.git',
      #source    => 'https://github.com/archivesspace/archivesspace.git',
      #source    => 'git://github.com/archivesspace/archivesspace',
      source    => 'git://github.com/NYULibraries/archivesspace.git',
      #revision => 'master',
      #notify    => File['/opt/archivesspace'],
    }
  }

  file { "${install_dir}/" :
    ensure  => directory,
    recurse => true,
    owner   => 'vagrant',
    group   => 'vagrant',
  }

    #file { "${install_location}/lib/mysql-connector-java-5.1.34.jar":
    #ensure  => file,
    #source  => 'puppet:///modules/archivesspace/mysql-connector-java-5.1.34.jar',
    ##require => File['/usr/local/archivesspace'],
    #owner   => 'root',
    #group   => 'root',
    #mode    => '0644',
    #require => Puppi::Netinstall['netinstall-archivesspace'],
    #}

    #file { "${install_location}/config/config.rb":
    #ensure   => file,
    #source   => 'puppet:///modules/archivesspace/config.rb',
    #owner    => 'root',
    #group    => 'root',
    #mode     => '0644',
    #require  => Puppi::Netinstall['netinstall-archivesspace'],
    #}

  # Link to the startup script
  #file { '/etc/init.d/archivesspace':
  #  ensure  => link,
  #  target  => "${install_locaiton}/archivesspace.sh',
  #}


  ## To get the setup-database.sh script to work I had to run it
  ## after the initial puppet run.  As a result load_db_tables and
  ## service start are manage by vagrant for now.
  ##
  #exec { 'load_db_tables':
  #  command     => '/usr/local/archivesspace/scripts/setup-database.sh',
  #  #refreshonly => true,
  #}
  #service { 'archivesspace':
  #  enable => true,
  #  ensure => 'running',
  #}


}
