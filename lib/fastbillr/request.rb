module Fastbillr
  class Request
    class << self

      def post(body = "")
        connection.post(body: body)
      end

      private

        def auth_string
          ["#{Configuration.email}:#{Configuration.api_key}"].pack('m').delete("\r\n")
        end

        def header
          {"Content-Type" => "application/json", "Authorization" => "Basic #{auth_string}" }
        end

        def connection
          Excon.new(Configuration.base_url, :headers => header)
        end
    end
  end
end
