require "fastbillr/version"

module Fastbillr
  require "excon"
  require "json"
  require "hashie"

  autoload :Configuration, "fastbillr/configuration"
  autoload :Request, "fastbillr/request"
  autoload :Result, "fastbillr/result"
  autoload :Error, "fastbillr/error"
end
