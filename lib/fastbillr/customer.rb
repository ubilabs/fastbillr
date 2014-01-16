module Fastbillr
  class Customer < Fastbillr::Dash
    [
      :customer_id,
      :customer_number, :days_for_payment, :created, :payment_type, :bank_name,
      :bank_account_number, :bank_code, :bank_account_owner, :bank_iban,
      :bank_bic, :show_payment_notice, :account_receivable, :customer_type,
      :top, :organization, :position, :salutation, :first_name, :last_name,
      :address, :address_2, :zipcode, :city, :country_code, :phone, :phone_2,
      :fax, :mobile, :email, :vat_id, :currency_code, :newsletter_optin,
      :lastupdate
    ].each {|property| property property }

    alias id customer_id

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
          customer.customer_id = response["CUSTOMER_ID"]
          customer
        end
      end

      def update(customer)
        if customer.id.nil?
          {errors: ["id is nil"]}
        else
          response = Fastbillr::Request.post({"SERVICE" => "customer.update", "DATA" => upcase_keys_in_hashes(customer)}.to_json)
          if response["ERRORS"]
            {errors: response["ERRORS"]}
          else
            customer
          end
        end
      end
    end
  end
end
