require 'spec_helper'

describe 'gnocchi::client' do

  shared_examples_for 'gnocchi client' do

    it { is_expected.to contain_class('gnocchi::deps') }
    it { is_expected.to contain_class('gnocchi::params') }

    it 'installs gnocchi client package' do
      is_expected.to contain_package('python-gnocchiclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          if facts[:os_package_type] == 'debian'
            { :client_package_name => 'python3-gnocchiclient' }
          else
            { :client_package_name => 'python-gnocchiclient' }
          end
        when 'RedHat'
          { :client_package_name => 'python-gnocchiclient' }
        end
      end

      it_behaves_like 'gnocchi client'
    end
  end

end
