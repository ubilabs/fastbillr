require File.expand_path("../test_helper", __FILE__)

describe Fastbillr::Configuration do

  it "saves email and api key" do
    email = "test@test.com"
    api_key = "kjashd87hjdsh87huaiduh87hdhkasdjh87"

    Fastbillr::Configuration.configure do |conf|
      conf.email = email
      conf.api_key = api_key
    end
    Fastbillr::Configuration.email.must_equal email
    Fastbillr::Configuration.api_key.must_equal api_key
  end

end
