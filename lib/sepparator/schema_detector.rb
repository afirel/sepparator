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
      start_schema = for_hash(array.first)
      schema = array.reduce(start_schema) do |schema, entry|
        fit_schema entry, schema
      end
      schema.each do |key, type|
        if type.nil?
          # when all values were nil, set to Object
          schema[key] = Object
        end
      end
    end

    private
    def fit_schema(entry, schema=nil)
      entry_schema = for_hash entry
      return entry_schema unless schema
      raise ArgumentError, 'different key entries not (yet) supported' if entry_schema.keys != schema.keys

      schema.each do |key, type|
        if type == nil && entry_schema[key] != nil
          schema[key] = entry_schema[key]  # first not-nil value
        elsif type != nil && entry_schema[key] == nil
          # just ignore subsequent nil-values
        elsif type != Object && type != entry_schema[key]
          schema[key] = Object   # differing types, generalize to Object
        end
      end
      schema
    end

    def type_of_value(value)
      (value.nil?) ? nil : value.class
    end

  end

end
