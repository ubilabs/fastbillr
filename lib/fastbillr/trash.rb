module Fastbillr
  class Trash < Hashie::Trash
    class << self
      def new(hash)
        super(downcase_keys_in_hashes(hash))
      end

      def downcase_keys_in_hashes(hash)
        change_case_in_hashes(hash, :downcase)
      end

      def upcase_keys_in_hashes(hash)
        change_case_in_hashes(hash, :upcase)
      end

      private

      def change_case_in_hashes(enumerable, case_method)
        if enumerable.is_a?(Hash)
          enumerable.reduce({}) do |result, (key, value)|
            new_key = key.send(case_method)
            if value.is_a?(Enumerable)
              result[new_key] = change_case_in_hashes(value, case_method)
            else
              result[new_key] = value
            end
            result
          end
        else
          enumerable.map do |element|
            change_case_in_hashes(element, case_method)
          end
        end
      end
    end

    def property_exists?(property)
      self.class.property?(property.to_sym) ? true : false
    end
  end
end
