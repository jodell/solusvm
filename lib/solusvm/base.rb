module Solusvm
  # Solusvm::Base is the main class for mapping API resources as subclasses.
  class Base
    attr_reader :returned_parameters, :statusmsg
    VALID_SERVER_TYPES = ['openvz', 'xen', 'xen hvm']

    # Prepares and sends the API request to the URL specificed in Solusvm.config
    #
    #
    #  class MyClass < Base
    #    def create_server(name)
    #      perform_request(:action => 'name', :id => 1)
    #    end
    #  end
    # Options:
    # * <tt>:action</tt> - Specifies which API method to execute
    # All other options passed in are converted to http query arguments and are passed along to the API
    def perform_request(options = {})
      options.merge!(api_login)
      http = Net::HTTP.new(api_endpoint.host, api_endpoint.port)
      if api_endpoint.port == 443
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.start do |http|
        request = Net::HTTP::Get.new("#{api_endpoint.path}?#{options.to_query}")
        response = http.request(request)
        @returned_parameters = parse_response(response.body)
      end
      successful?
    end

    # Converts the XML response to a Hash
    def parse_response(body)
      XmlHelper.new("<solusrequest>#{body}</solusrequest>").output
    end

    # Returns true when a request has been successful
    # 
    #   my_class = MyClass.new
    #   my_class.create_server('example.com')
    #   my_class.successful? # => true
    def successful?
      returned_parameters['status'] == 'success'
    end

    # URI parsed API URL
    def api_endpoint
      Solusvm.api_endpoint
    end

    def api_login
      {:id => Solusvm.api_id, :key => Solusvm.api_key}
    end

    # API response message
    def statusmsg
      returned_parameters['statusmsg']
    end

    # Raises an exception unless a valid type is specified
    def validate_server_type!(type)
      type.strip!
      unless VALID_SERVER_TYPES.include?(type)
        raise SolusvmError, "Invalid Virtual Server type: #{type}"
      end
    end
  end
end