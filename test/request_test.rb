require File.expand_path("../test_helper", __FILE__)

module Fastbillr
  class Request
    private
      def self.connection
        Excon.new(Configuration.base_url, :headers => header, mock: true)
      end
  end
end

describe Fastbillr::Request do
  let(:email) { "test@test.com" }
  let(:api_key) { "kjashd87hjdsh87huaiduh87hdhkasdjh87" }
  let(:auth_string) { ["#{email}:#{api_key}"].pack("m").delete("\r\n") }
  let(:header) { { "Content-Type" => "application/json", "Authorization" => "Basic #{auth_string}" } }

  before do
    Fastbillr::Configuration.configure do |conf|
      conf.email = email
      conf.api_key = api_key
    end
  end

  describe "private" do
    it "#auth_string" do
      Fastbillr::Request.send(:auth_string).must_equal auth_string
    end

    it "#header" do
      Fastbillr::Request.send(:header).must_equal header
    end

    it "#connection" do
      excon_connection = Fastbillr::Request.send(:connection)
      excon_connection.must_be_instance_of(Excon::Connection)
      excon_connection.connection[:headers].must_equal header
    end
  end

  describe "http methods" do
    it "#post" do
      Excon.stub({:method => :post}, {:body => fixture_file("customer_get.json"), :status => 200})
      result = Fastbillr::Request.post('{"SERVICE": "customer.get"}')
      result.status.must_equal 200
    end
  end

end
