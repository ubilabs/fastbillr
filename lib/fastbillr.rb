require "fastbillr/version"

module Fastbillr
  # From the FastBill API documentation:
  # "Die maximale Anzahl von Elementen beim Abruf einer Liste beträgt 100,
  # unabhängig vom gewählten „LIMIT“-Wert."
  MAX_RESULT_ELEMENTS = 100

  require "excon"
  require "json"
  require "hashie"

  autoload :Configuration, "fastbillr/configuration"
  autoload :Request, "fastbillr/request"
  autoload :Result, "fastbillr/result"
  autoload :Error, "fastbillr/error"
  autoload :Dash, "fastbillr/dash"
  autoload :Customer, "fastbillr/customer"
  autoload :Invoice, "fastbillr/invoice"
end
