require 'spec_helper'
require 'sepparator/spreadsheet_converter'
require 'tempfile'
require 'fileutils'

describe Sepparator::SpreadsheetConverter do

  it 'remembers the column separator' do
    sep = 'foobar'
    expect(described_class.new(col_sep: sep).col_sep).to eq(sep)
  end

  context '#convert_from_string' do
    let(:csv_string) { File.open(File.join(__dir__, 'example.csv')).read }
    let(:xls_path) { Tempfile.new('convert-to-xlsx').path }
    subject { described_class.new.convert_from_string(csv_string, xls_path) }

    before { FileUtils.rm_f xls_path }

    it "converts a csv string" do
      # don't comparing xlsx files here
      subject
      expect(File.exists?(xls_path)).to be_true
    end
    it 'raises when the destination file already exists' do
      expect{described_class.new.convert('/some/non/existing/file.csv', Tempfile.new('blafoo').path)}.to raise_error(ArgumentError, /destination file exists/)
    end
  end
  context '#convert' do
    #let(:xls_path) { Tempfile.new('convert-to-xlsx')}
    let(:xls_path) { '/tmp/example.xlsx' }
    let(:csv_path) { File.join(__dir__, 'example.csv')}
    subject { described_class.new.convert(csv_path, xls_path)}

    before do
      FileUtils.rm_f xls_path
    end

    it 'converts a CSV file' do
      # don't comparing xlsx files here
      subject
      expect(File.exists?(xls_path)).to be_true
    end

    it 'raises when the source file was not found' do
      expect{described_class.new.convert('/some/non/existing/file.csv', xls_path)}.to raise_error(ArgumentError, /file not found/)
    end

    it 'raises when the destination file already exists' do
      expect{described_class.new.convert('/some/non/existing/file.csv', Tempfile.new('blafoo').path)}.to raise_error(ArgumentError, /destination file exists/)
    end
  end

end
