module Solusvm
  class Server < Base
    def create(hostname, password, options = {})
      options.reverse_merge!(
        :type         => 'xen',
        :username     => nil,
        :ips          => 1,
        :node         => nil,
        :plan         => nil,
        :template     => nil,
        :password     => password,
        :hostname     => hostname
      ).merge!(:action => 'vserver-create')
      perform_request(options)
      returned_parameters
    end

    def boot(vid)
      perform_request(:action => 'vserver-boot', :vserverid => vid)
    end

    def reboot(vid)
      perform_request(:action => 'vserver-reboot', :vserverid => vid)
    end

    def suspend(vid)
      perform_request(:action => 'vserver-suspend', :vserverid => vid)
    end

    def resume(vid)
      perform_request(:action => 'vserver-unsuspend', :vserverid => vid)
    end

    def shutdown(vid)
      perform_request(:action => 'vserver-shutdown', :vserverid => vid)
    end

    def tun_enable(vid)
      perform_request(:action => 'vserver-tun-enable', :vserverid => vid)
    end

    def tun_disable(vid)
      perform_request(:action => 'vserver-tun-disable', :vserverid => vid)
    end

    def network_enable(vid)
      perform_request(:action => 'vserver-network-enable', :vserverid => vid)
    end

    def network_disable(vid)
      perform_request(:action => 'vserver-network-disable', :vserverid => vid)
    end

    def pae_enable(vid)
      perform_request(:action => 'vserver-pae', :vserverid => vid, :pae => "on")
    end

    def pae_disable(vid)
      perform_request(:action => 'vserver-pae', :vserverid => vid, :pae => "off")
    end

    def terminate(vid, deleteclient = false)
      perform_request(:action => 'vserver-terminate', :vserverid => vid, :deleteclient => deleteclient)
    end

    def exists?(vid)
      perform_request(:action => 'vserver-checkexists', :vserverid => vid)
      !statusmsg.match(/Virtual server exists/i).nil?
    end

    def status(vid)
      perform_request(:action => 'vserver-status', :vserverid => vid)
      statusmsg
    end

    def add_ip(vid)
      perform_request(:action => 'vserver-addip', :vserverid => vid)
    end

    def change_plan(vid, plan)
      perform_request(:action => 'vserver-change', :vserverid => vid, :plan => plan)
    end

    def change_owner(vid, client_id)
      perform_request(:action => 'vserver-changeowner', :vserverid => vid, :clientid => client_id)
    end

    def change_consolepass(vid, password)
      perform_request(:action => 'vserver-consolepass', :vserverid => vid, :consolepassword => password)
    end

    def change_vncpass(vid, password)
      perform_request(:action => 'vserver-vncpass', :vserverid => vid, :vncpassword => password)
    end

    def info(vid, reboot = false)
      perform_request(:action => 'vserver-info', :vserverid => vid, :reboot => reboot)
      returned_parameters
    end

    def vnc(vid)
      perform_request(:action => 'vserver-vnc', :vserverid => vid)
      returned_parameters
    end

    def console(vid)
      perform_request(:action => 'vserver-console', :vserverid => vid)
      returned_parameters
    end
    
    def info_all(vid)
      perform_request(:action => 'vserver-infoall', :vserverid => vid)
      returned_parameters
    end

    def rebuild(vid, template)
      perform_request(:action => 'vserver-rebuild', :vserverid => vid, :template => template)
    end

    def mountiso(vid, iso)
      perform_request(:action => 'vserver-mountiso', :vserverid => vid, :iso => iso)
    end

    def unmountiso(vid)
      perform_request(:action => 'vserver-unmountiso', :vserverid => vid)
    end
  end
end
