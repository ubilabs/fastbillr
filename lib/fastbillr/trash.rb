module Fastbillr
  class Trash < Hashie::Trash
    class << self
      def downcase_method_names!(method_names)
        method_names.each do |method_name|
          property method_name.downcase, from: method_name
        end
      end
    end

    def to_uppercase_attribute_names
      self.to_hash.inject({}) do |result, (key, value)|
        result[key.upcase] = value
        result
      end
    end

    def property_exists?(property)
      self.class.property?(property.to_sym) ? true : false
    end
  end
end
