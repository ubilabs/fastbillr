require File.expand_path("../test_helper", __FILE__)

describe Fastbillr::Customer do
  after do
    Excon.stubs.clear
  end

  describe "find methods" do

    describe "customers" do
      before do
        Excon.stub({:method => :post}, {:body => fixture_file("customers.json"), :status => 200})
      end

      it "#all" do
        customers = Fastbillr::Customer.all
        customers.length.must_equal 2
        expected_ids = JSON.parse(fixture_file("customers.json"))["RESPONSE"]["CUSTOMERS"].map { |c| c["CUSTOMER_ID"] }
        customers.map { |c| c.id }.must_equal expected_ids
      end

      it "#find_by_country" do
        expected_ids = JSON.parse(fixture_file("customers.json"))["RESPONSE"]["CUSTOMERS"].map { |c| c["CUSTOMER_ID"] }
        Fastbillr::Customer.find_by_country("de").map(&:id).must_equal expected_ids
      end
    end

    describe "customer" do
      before do
        Excon.stub({:method => :post}, {:body => fixture_file("customer.json"), :status => 200})
      end

      it "#find_by_id" do
        expected_customer_id = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_ID"]
        Fastbillr::Customer.find_by_id(expected_customer_id).id.must_equal expected_customer_id
      end

      it "#search" do
        expected_id = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_ID"]
        Fastbillr::Customer.search("foo").first.id.must_equal expected_id
      end
    end

  end
end
