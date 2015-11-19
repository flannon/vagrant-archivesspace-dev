node default {
  #Yumrepo <| |> -> Package <| provider != 'rpm' |>


  Firewall {
    before => Class['fw::post'],
    require => Class['fw::pre'],
  }

  include epel
  include housekeeping
  class { ['fw::pre', 'fw::post']: }
  class { 'firewall': }
  #include '::gnupg'
  #gnupg_key { 'hkp_server_BF04FF17':
  #gnupg_key { 'hkp_server_D39DC0E3':
  #  ensure      => present,
  #  #key_id     => 'BF04FF17',
  #  key_id      => 'D39DC0E3',
  #  user        => 'root',
  #  #key_server => 'hkp://keys.gnupg.net/',
  #  key_source  => 'puppet:///modules/gnupg/mpapis.asc',
  #  key_type    => public,
  #}

  include java
  include motd
  class { 'python' :
    version => 'system',
    pip     => 'present',
  }
  python::pip { 'awscli' :
    ensure  => 'present',
    pkgname => 'awscli',
  }
  class {'repoforge' :
    enabled =>  ['rpmforge', 'extras'],
  }
  #class { '::rvm': gnupg_key_id => false, }
  class { '::rvm': }
  rvm::system_user { 'root': ; 'vagrant': ; }
  rvm_system_ruby {
    'ruby-1.9.3-p551':
      ensure      => 'present',
      default_use => true,
  }
  rvm_gemset {
    'ruby-1.9.3-p551@aspace':
      ensure  => present,
      require => Rvm_system_ruby['ruby-1.9.3-p551'];
  }
  rvm_gem { 'bundler':
    ensure       => latest,
    name         => 'bundler',
    #ruby_version => 'ruby-2.1.3',
    ruby_version => 'ruby-1.9.3-p551',
    #require      => Rvm_system_ruby['ruby-2.1.3'];
    require      => Rvm_system_ruby['ruby-1.9.3-p551'];
  }
  rvm_gem { 'librarian-puppet':
    ensure       => latest,
    name         => 'librarian-puppet',
    #ruby_version => 'ruby-2.1.3',
    ruby_version => 'ruby-1.9.3-p551',
    #require      => Rvm_system_ruby['ruby-2.1.3'];
    require      => Rvm_system_ruby['ruby-1.9.3-p551'];
  }
  class { '::mysql::server':
    root_password           => 'vagrant',
    remove_default_accounts => true,
    service_enabled         => true,
    require                 => Class['housekeeping'],
  }
  mysql::db { 'asdb':
    ensure   => 'present',
    charset  => 'utf8',
    user     => 'as',
    password => 'vagrant',
    dbname   => 'asdb',
  }
  #mysql::bindings {
  #  java_enable => true,
  #  ruby_enable => true,
  #}
  include mysql::client
  #include mysql::bindings::java
  include mysql::bindings
  include stdlib

  #puppi::netinstall { 'netinstall-archivesspace':
  #  url                 => 'https://github.com/archivesspace/archivesspace/releases/download/v1.4.1/archivesspace-v1.4.1.zip',
  #  extracted_dir       => 'archivesspace',
  #  destination_dir     => '/tmp',
  #  postextract_command => 'mv -f /tmp/archivesspace /usr/local/archivesspace',
  #}
  class { 'archivesspace':
    #version     => '1.4.2',
    #require     => Class['housekeeping'],
    install_type => dev,
    #require      => [ Package['unzip'], Class['vcsrepo'] ],
    require      =>  Package['unzip'],
    #  require   => Puppi::Netinstall['netinstall-archivesspace'],
    #creates     => '/usr/local/archivesspace/archivesspace',
  }
  firewall { '100 allow archivesspace access':
    dport   => [8080, 8081, 8089, 8090, 8091],
    proto  => tcp,
    action => accept,
  }

  include vim

}
