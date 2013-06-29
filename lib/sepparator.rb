Dir[File.join(__dir__, 'sepparator/**/*.rb')].each { |f| require f }

module Sepparator
  extend self

  def start_console(args)
    Console.start(args)
  end

end
