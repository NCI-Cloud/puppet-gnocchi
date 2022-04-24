# Installs & configure the gnocchi statsd service
#
# == Parameters
#
# [*resource_id*]
#   (required) Resource UUID to use to identify statsd in Gnocchi.
#
# [*host*]
#   (optional) The listen IP for statsd.
#   Defaults to $::os_service_default
#
# [*port*]
#   (optional) The port for statsd.
#   Defaults to $::os_service_default.
#
# [*flush_delay*]
#   (optional) Delay between flushes.
#   Defaults to $::os_service_default
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*archive_policy_name*]
#   (optional) Archive policy name to use when creating metrics.
#   Defaults to $::os_service_default.
#
class gnocchi::statsd (
  $resource_id,
  $host                = $::os_service_default,
  $port                = $::os_service_default,
  $flush_delay         = $::os_service_default,
  $archive_policy_name = $::os_service_default,
  $manage_service      = true,
  $enabled             = true,
  $package_ensure      = 'present',
) inherits gnocchi::params {

  include gnocchi::deps

  package { 'gnocchi-statsd':
    ensure => $package_ensure,
    name   => $::gnocchi::params::statsd_package_name,
    tag    => ['openstack', 'gnocchi-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'gnocchi-statsd':
      ensure     => $service_ensure,
      name       => $::gnocchi::params::statsd_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['gnocchi-service', 'gnocchi-db-sync-service'],
    }
  }

  gnocchi_config {
    'statsd/resource_id'         : value => $resource_id;
    'statsd/host'                : value => $host;
    'statsd/port'                : value => $port;
    'statsd/archive_policy_name' : value => $archive_policy_name;
    'statsd/flush_delay'         : value => $flush_delay;
  }

}
