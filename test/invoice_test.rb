require File.expand_path("../test_helper", __FILE__)

describe Fastbillr::Invoice do
  after do
    Excon.stubs.clear
  end

  describe "find methods" do
    describe "invoice" do
      before do
        Excon.stub({method: :post}, {body: fixture_file("invoice.json"), status: 200})
      end

      it ".find_by_id" do
        expected_invoice_id = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        assert_equal expected_invoice_id, Fastbillr::Invoice.find_by_id(expected_invoice_id).id
      end

      it ".find_by_invoice_number" do
        expected_invoice_number = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_NUMBER"]
        assert_equal expected_invoice_number, Fastbillr::Invoice.find_by_id(expected_invoice_number).invoice_number
      end

      it ".all_by_customer_id" do
        customer_id = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["CUSTOMER_ID"]
        assert_equal customer_id, Fastbillr::Invoice.all_by_customer_id(customer_id).first.customer_id
      end
    end

    describe ".create" do
      it "success" do
        Excon.stub({method: :post}, {body: fixture_file("created_invoice.json"), status: 200})
        Excon.stub({method: :post}, {body: fixture_file("invoice_draft.json"), status: 200})
        invoice = Fastbillr::Invoice.create(
          customer_id: "60547", introtext: "Das ist der Einleitungssatz.",
          invoice_date: "2012-03-05", delivery_date: "M\u00e4rz 2012",
          items: {
            item: [
              {
                description: "Postenbezeichnung 1",
                unit_price: "40.00",
                vat_percent: "19.00",
                quantity: "10"
              },
              {
                description: "Postenbezeichnung 2",
                unit_price: "30.00",
                vat_percent: "19.00",
                quantity: "20"
              }
            ]
          }
        )
        assert_equal JSON.parse(fixture_file("created_invoice.json"))["RESPONSE"]["INVOICE_ID"], invoice.id
        assert_equal "draft", invoice.type
        assert_equal 1190, invoice.total
      end

      it "error" do
        Excon.stub({method: :post}, {body: fixture_file("invoice_create_error.json"), status: 200})
        assert_raises Fastbillr::Error do
          assert Fastbillr::Invoice.create({})
        end
      end
    end

    describe ".complete" do
      it "error" do
        Excon.stub({method: :post}, {body: fixture_file("invoice.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        Excon.stub({method: :post}, {body: fixture_file("invoice_complete_error.json"), status: 200})
        e = assert_raises Fastbillr::Error do # no draft
          Fastbillr::Invoice.complete(invoice)
        end
        assert_equal "Invoice Error: No draft invoice chosen.", e.message
      end
    end

    describe ".delete" do
      it "error" do
        Excon.stub({method: :post}, {body: fixture_file("invoice.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        e = assert_raises Fastbillr::Error do
          Fastbillr::Invoice.delete(invoice)
        end
        assert_equal "no draft", e.message
      end
    end

    describe ".cancel" do
      it "draft" do
        Excon.stub({method: :post}, {body: fixture_file("invoice_draft.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice_draft.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        e = assert_raises Fastbillr::Error do
          Fastbillr::Invoice.cancel(invoice)
        end
        assert_equal "draft", e.message
      end

      it "already canceled" do
        Excon.stub({method: :post}, {body: fixture_file("invoice_canceled.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice_canceled.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        e = assert_raises Fastbillr::Error do
          Fastbillr::Invoice.cancel(invoice)
        end
        assert_equal "already canceled", e.message
      end
    end

    describe ".setpaid" do
      it "success" do
        Excon.stub({method: :post}, {body: fixture_file("invoice.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        assert_equal "", invoice.invoice_number
        assert_equal "0000-00-00 00:00:00", invoice.paid_date
        Excon.stub({method: :post}, {body: fixture_file("invoice_paid.json"), status: 200})
        invoice = Fastbillr::Invoice.setpaid(invoice)
        assert invoice.invoice_number != ""
        assert invoice.paid_date != "0000-00-00 00:00:00"
      end

      it "error" do
        Excon.stub({method: :post}, {body: fixture_file("invoice_paid.json"), status: 200})
        invoice_id = JSON.parse(fixture_file("invoice_paid.json"))["RESPONSE"]["INVOICES"][0]["INVOICE_ID"]
        invoice = Fastbillr::Invoice.find_by_id(invoice_id)
        Excon.stub({method: :post}, {body: fixture_file("invoice_setpaid_error.json"), status: 200})
        e = assert_raises Fastbillr::Error do
          Fastbillr::Invoice.setpaid(invoice)
        end
        assert_equal "Invoice Error: Invoice could not be set paid. Maybe it is already?", e.message
      end
    end
  end
end
