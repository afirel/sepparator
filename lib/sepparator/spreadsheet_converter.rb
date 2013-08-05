require 'simple_xlsx'
require 'csv'

module Sepparator

  class SpreadsheetConverter

    attr_reader :col_sep

    def initialize(col_sep: ';')
      @col_sep = col_sep
    end

    def convert(csv_path, xls_path, sheet_name: 'from CSV')
      raise ArgumentError, "file not found: #{csv_path}" unless File.exists?(csv_path)
      create_xlsx(xls_path, sheet_name) do |sheet|
        CSV.foreach(csv_path, col_sep: col_sep, converters: [:numeric, :date_time, :date]) do |csv_row|
          sheet.add_row(csv_row)
        end
      end
    end

    def convert_from_string(csv_string, xls_path, sheet_name: 'from CSV')
      create_xlsx(xls_path, sheet_name) do |sheet|
        CSV.parse(csv_string, col_sep: col_sep, converters: [:numeric, :date_time, :date]) do |csv_row|
          sheet.add_row(csv_row)
        end
      end
    end

    private
    def create_xlsx(xls_path, sheet_name)
      raise ArgumentError, "destination file exists: #{xls_path}" if File.exists?(xls_path)
      SimpleXlsx::Serializer.new(xls_path) do |doc|
        doc.add_sheet(sheet_name || 'from CSV') do |sheet|
          yield sheet
        end
      end
    end

  end

end
