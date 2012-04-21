module Fastbillr
  class Configuration

    class << self
      attr_accessor :email, :api_key

      def configure
        yield self
      end
    end

  end
end
