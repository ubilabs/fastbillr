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

      it "#find_by_customer_number" do
        expected_customer_number = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_NUMBER"]
        Fastbillr::Customer.find_by_customer_number(expected_customer_number).customer_number.must_equal expected_customer_number
      end

      it "#search" do
        expected_id = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_ID"]
        Fastbillr::Customer.search("foo").first.id.must_equal expected_id
      end
    end

  end

  describe "create, delete, update" do
    it "#create success" do
      Excon.stub({:method => :post}, {:body => fixture_file("created_customer.json"), :status => 200})
      customer = Fastbillr::Customer.create(last_name: "foo", first_name: "bar", city: "dummy", customer_type: "business", organization: "foobar")
      customer.id.must_equal JSON.parse(fixture_file("created_customer.json"))["RESPONSE"]["CUSTOMER_ID"]
    end

    it "#create error" do
      Excon.stub({:method => :post}, {:body => fixture_file("customer_create_error.json"), :status => 200})
      assert_raises Fastbillr::Error do
        Fastbillr::Customer.create({})
      end
    end

    it "#update success" do
      Excon.stub({:method => :post}, {:body => fixture_file("created_customer.json"), :status => 200})
      customer = Fastbillr::Customer.create(last_name: "foo", first_name: "bar", city: "dummy", customer_type: "business", organization: "foobar")
      Excon.stub({:method => :post}, {:body => fixture_file("updated_customer.json"), :status => 200})
      customer.last_name = "Föö"
      customer = Fastbillr::Customer.update(customer)
      assert_equal "Föö", customer.last_name
    end

    it "#update error" do
      e = assert_raises Fastbillr::Error do
        Fastbillr::Customer.update(Fastbillr::Customer.new({}))
      end
      assert_equal "id is nil", e.message
    end
  end
end
