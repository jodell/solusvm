module Solusvm
  # Solusvm::Client is the class for working with clients
  class Client < Base
    # Creates a client
    #
    # Options:
    # * <tt>:username</tt>
    # * <tt>:password</tt>
    # * <tt>:email</tt>
    # * <tt>:firstname</tt>
    # * <tt>:lastname</tt>
    def create(options ={})
      options.merge!(:action => 'client-create')
      perform_request(options)
    end

    # Change client password for the solus admin
    def change_password(username, password)
      perform_request({:action => "client-updatepassword", :username => username, :password => password})
    end

    # Checks wether a specific client exists
    def exists?(username)
      perform_request({:action => 'client-checkexists', :username => username})
    end

    # Verify a clients login. Returns true when the specified login is correct
    def authenticate(username, password)
      perform_request({:action => 'client-authenticate', :username => username, :password => password})
    end

    # Deletes a client
    def delete(username)
      perform_request({:action => "client-delete", :username => username})
    end

    # Lists clients
    def list
      perform_request({:action => "client-list"}, "client")

      if returned_parameters["clients"] && returned_parameters["clients"]["client"]
        returned_parameters["clients"]["client"]
      elsif returned_parameters["clients"]
        []
      end
    end
  end
end
