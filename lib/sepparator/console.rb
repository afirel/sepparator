require 'thor'

module Sepparator
  class Console < Thor

    option :col_sep, aliases: ['-s'], desc: 'CSV column separator, defaults to tab-separated values', banner: '\t'
    option :force, type: :boolean, aliases: ['-f'], desc: 'overwrite existing files'
    desc "convert CSV XLS", "converts a csv to a .xlsx Excel file"
    long_desc <<-LONGDESC
      `sepp convert` converts a CSV file to a xlsx file.

      Parameters:\x5

      CSV - path to a CSV file (required)

      XLS - destination path for excel file (optional)\x5
            Use --force to overwrite existing files.\x5
            If XLS is ommited, sepp will create the excel file
            alongside the csv using the .xlsx extension.

      Options:

      --col_sep - CSV column separation character(s)

      --force   - overwrite destination files if necessary
    LONGDESC
    def convert(csv_path, xls_path=nil)
      xls_path ||= csv_path.gsub(/\.csv/, '.xlsx')
      converter = Sepparator.spreadsheet_converter(col_sep: options['col_sep'] || "\t")

      File.unlink(xls_path) if File.exists?(xls_path) && options.include?('force')

      if File.exists?(xls_path)
        STDERR.puts "destination file exists, use --force to overwrite: #{xls_path}"
        exit(1)
      elsif (not File.exists?(csv_path))
        STDERR.puts "csv file not found: #{csv_path}"
        exit(2)
      end

      begin
        converter.convert(csv_path, xls_path)
      rescue ArgumentError => e
        STDERR.puts e.message
        exit(3)
      end
    end

  end
end
