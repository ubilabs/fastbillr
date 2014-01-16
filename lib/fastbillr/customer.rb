module Fastbillr
  class Customer < Fastbillr::Trash

    property :id, from: :CUSTOMER_ID
    UPPERCASE_METHOD_NAMES = [
      :CUSTOMER_NUMBER, :DAYS_FOR_PAYMENT, :CREATED, :PAYMENT_TYPE,
      :BANK_NAME, :BANK_ACCOUNT_NUMBER, :BANK_CODE, :BANK_ACCOUNT_OWNER, :BANK_IBAN, :BANK_BIC,
      :SHOW_PAYMENT_NOTICE, :ACCOUNT_RECEIVABLE, :CUSTOMER_TYPE,
      :TOP, :ORGANIZATION, :POSITION, :SALUTATION, :FIRST_NAME, :LAST_NAME, :ADDRESS, :ADDRESS_2,
      :ZIPCODE, :CITY, :COUNTRY_CODE, :PHONE, :PHONE_2, :FAX, :MOBILE, :EMAIL, :VAT_ID,
      :CURRENCY_CODE, :NEWSLETTER_OPTIN, :LASTUPDATE
    ]
    downcase_method_names!(UPPERCASE_METHOD_NAMES)

    class << self
      def all
        Fastbillr::Request.post('{"SERVICE": "customer.get"}')["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def find_by_id(id)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"CUSTOMER_ID" => id.to_i}}.to_json)
        new(response["CUSTOMERS"][0])
      end

      def find_by_customer_number(id)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"CUSTOMER_NUMBER" => id.to_i}}.to_json)
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
        response = Fastbillr::Request.post({"SERVICE" => "customer.create", "DATA" => upcase_keys_in_hashes(customer)}.to_json)
        if response["ERRORS"]
          {errors: response["ERRORS"]}
        else
          customer.id = response["CUSTOMER_ID"]
          customer
        end
      end
    end
  end
end
