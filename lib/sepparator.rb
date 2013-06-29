Dir[File.join(__dir__, 'sepparator/**/*.rb')].each { |f| require f }

module Sepparator
  extend self

  def start_console(args)
    Console.start(args)
  end

  def spreadsheet_converter(opts = Hash.new)
    SpreadsheetConverter.new(opts)
  end

end
