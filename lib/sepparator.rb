Dir[File.join(__dir__, 'sepparator/**/*.rb')].each { |f| require f }

module Sepparator
  extend self

  def start_console(args)
    Console.start(args)
  end

  def csv_to_excel(csv_path, excel_path, col_sep: ';', sheet_name: 'from CSV')
    converter = SpreadsheetConverter.new(col_sep: col_sep)
    converter.convert(csv_path, excel_path, sheet_name: sheet_name)
  end

end
