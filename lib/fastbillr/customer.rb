module Fastbillr
  class Customer < Hashie::Trash

    property :id, from: :CUSTOMER_ID
    UPERCASE_METHOD_NAMES = [
      :CUSTOMER_NUMBER, :DAYS_FOR_PAYMENT, :CREATED, :PAYMENT_TYPE, :BANK_NAME, :BANK_ACCOUNT_NUMBER,
      :BANK_CODE, :BANK_ACCOUNT_OWNER, :SHOW_PAYMENT_NOTICE, :ACCOUNT_RECEIVABLE, :CUSTOMER_TYPE,
      :TOP, :ORGANIZATION, :POSITION, :SALUTATION, :FIRST_NAME, :LAST_NAME, :ADDRESS, :ADDRESS_2,
      :ZIPCODE, :CITY, :COUNTRY_CODE, :PHONE, :PHONE_2, :FAX, :MOBILE, :EMAIL, :VAT_ID, :CURRENCY_CODE
    ]
    UPERCASE_METHOD_NAMES.each do |method_name|
      property method_name.downcase, from: method_name
    end

    class << self
      def all
        Fastbillr::Request.post('{"SERVICE": "customer.get"}')["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def find_by_id(id)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"CUSTOMER_ID" => id.to_i}}.to_json)
        new(response["CUSTOMERS"][0])
      end

      def find_by_country(country_code)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"COUNTRY_CODE" => country_code.upcase}}.to_json)
        response["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def search(term)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"TERM" => term}}.to_json)
        response["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def create(params)
        customer = new(params)
        response = Fastbillr::Request.post({"SERVICE" => "customer.create", "DATA" => customer.to_uppercase_attribute_names}.to_json)
        customer.id = response["CUSTOMER_ID"]
        customer
      end
    end

    def to_uppercase_attribute_names
      self.to_hash.inject({}) do |result, (key, value)|
        result[key.upcase] = value
        result
      end
    end

  end
end
