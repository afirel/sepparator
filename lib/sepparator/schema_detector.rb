module Sepparator

  class SchemaDetector

    def for_hash(hash)
      schema = {}
      hash.each_with_object(schema) do |(k,v),schema|
        schema[k] = type_of_value(v)
      end
    end

    def for_array(array)
      return {} if array.empty?
      schema = for_hash array.first
      array.each do |entry|
        entry_schema = for_hash entry
        if entry_schema.keys != schema.keys
          raise ArgumentError, 'different width entries not (yet) supported'
        end
        schema.each do |key, type|
          if type == nil && entry_schema[key] != nil
            schema[key] = entry_schema[key]  # first not-nil value
          elsif type != nil && entry_schema[key] == nil
            # just ignore subsequent nil-values
          elsif type != Object && type != entry_schema[key]
            schema[key] = Object   # differing types, generalize to Object
          end
        end
      end
      schema.each do |key, type|
        if type.nil?
          # when all values are nil, set to Object
          schema[key] = Object
        end
      end

    end

    private
    def type_of_value(value)
      (value.nil?) ? nil : value.class
    end

  end

end
