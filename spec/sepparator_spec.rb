require 'spec_helper'

describe Sepparator do

  context '.csv_to_excel' do
    it 'creates a converter and uses it appropriately' do
      col_sep = ','
      csv_path = 'foo/bar.csv'
      xls_path = 'bla/fu.xls'
      sheet_name = 'my sheet'
      converter = double
      Sepparator::SpreadsheetConverter.should_receive(:new).with(col_sep: col_sep).and_return(converter)
      converter.should_receive(:convert).with(csv_path, xls_path, sheet_name: sheet_name)

      Sepparator.csv_to_excel(csv_path, xls_path, sheet_name: sheet_name, col_sep: col_sep)
    end

  end

end

