# Fastbillr

Ruby API wrapper for the fastbill.com API

## Installation

Add this line to your application's Gemfile:

    gem 'fastbillr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fastbillr

## Usage

### Configuration

    Fastbillr::Configuration.configure do |config|
      config.email = "your@email.com"
      config.api_key = "yourverysecretapikey"
    end

### Customer

#### Get all customer
    Fastbillr::Customer.all

#### Find by country code
    Fastbillr::Customer.find_by_country("de")

#### Find by id
    Fastbillr::Customer.find_by_id(12)

#### Search by ORGANIZATION, FIRST_NAME, LAST_NAME, ADDRESS, ADDRESS_2, ZIPCODE, EMAIL
    Fastbillr::Customer.search("foo")

#### Create a new customer
There are different required fields depending on e.g. customer_type. Please refer the fastbill api documentation.
    
    Fastbillr::Customer.create(last_name: "foo", firstname: "bar")

## Run the test suite

    $ rake

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
