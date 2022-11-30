class elasticsearch_v8_x
(
  Integer $version = 8,
)
{

  class { 'java':
    distribution => jre,
  }
  
  yumrepo { 'elasticsearch':
    ensure     => 'present',
    descr      => "Elasticsearch repository for ${version}.x packages",
    gpgcheck   => '1',
    enabled    => '1',
    gpgkey     => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
    baseurl    => "https://artifacts.elastic.co/packages/${version}.x/yum",
  }
  ->
  package {'elasticsearch':
    ensure => installed,
    require => Class['java']
  }
  ->
  #elasticsearch.yaml configuration
  file {'/etc/elasticsearch/elasticsearch.yml':
    ensure => file,
    mode   => '0660',
    owner  => 'root',
    group  => 'elasticsearch',
    source => 'puppet:///modules/elasticsearchv8/elasticsearch.yml',
  }
  ->
  service {'elasticsearch':
    ensure => running,
    enable => true,
    require => Package['elasticsearch']
  }

}
