module Fastbillr
  class Invoice < Fastbillr::Dash
    [
      :invoice_id,
      :invoice_number, :customer_id, :month, :year, :start_due_date,
      :end_due_date, :state, :type, :project_id, :customer_number,
      :customer_costcenter_id, :organization, :salutation, :first_name,
      :last_name, :address, :address_2, :zipcode, :city, :country_code, :vat_id,
      :currency_code, :template_id, :introtext, :invoice_number, :paid_date,
      :is_canceled, :invoice_date, :due_date, :delivery_date, :eu_delivery,
      :cash_discount_percent, :cash_discount_days, :sub_total, :vat_total,
      :total, :vat_items, :items, :document_url
    ].each {|property| property property }

    alias id invoice_id

    class << self
      def find_by_id(id)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"INVOICE_ID" => id.to_i}}.to_json)
        new(response["INVOICES"][0]) if response && response["INVOICES"] && !response["INVOICES"].empty?
      end

      def find_by_invoice_number(id)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"INVOICE_NUMBER" => id.to_i}}.to_json)
        new(response["INVOICES"][0]) if response && response["INVOICES"] && !response["INVOICES"].empty?
      end

      def create(params)
        invoice = new(params)
        invoice_data = upcase_keys_in_hashes(comply_with_crappy_api(invoice))
        response = Fastbillr::Request.post({"SERVICE" => "invoice.create", "DATA" => invoice_data}.to_json)
        if response["ERRORS"]
          raise Error.new(response["ERRORS"].first)
        else
          find_by_id(response["INVOICE_ID"])
        end
      end

      def complete(invoice)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.complete", "DATA" => {"INVOICE_ID" => invoice.id}}.to_json)
        if response["ERRORS"]
          raise Error.new(response["ERRORS"].first)
        else
          find_by_id(response["INVOICE_ID"])
        end
      end

      def cancel(invoice)
        if invoice.is_canceled == "1"
          raise Error.new("already canceled")
        elsif invoice.type == "draft"
          raise Error.new("draft")
        else
          response = Fastbillr::Request.post({"SERVICE" => "invoice.cancel", "DATA" => {"INVOICE_ID" => invoice.id}}.to_json)
          if response["ERRORS"]
            raise Error.new(response["ERRORS"].first)
          else
            find_by_id(invoice.id)
          end
        end
      end

      def delete(invoice)
        if invoice.type != "draft"
          raise Error.new("no draft")
        else
          response = Fastbillr::Request.post({"SERVICE" => "invoice.delete", "DATA" => {"INVOICE_ID" => invoice.id}}.to_json)
          if response["ERRORS"]
            raise Error.new(response["ERRORS"].first)
          else
            invoice
          end
        end
      end

      def setpaid(invoice)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.setpaid", "DATA" => {"INVOICE_ID" => invoice.id}}.to_json)
        if response["ERRORS"]
          raise Error.new(response["ERRORS"].first)
        else
          find_by_id(invoice.id)
        end
      end

      private

      def comply_with_crappy_api(invoice)
        crappy_invoice = invoice.dup
        crappy_invoice.items = {item: invoice.items}
        crappy_invoice
      end
    end
  end
end
