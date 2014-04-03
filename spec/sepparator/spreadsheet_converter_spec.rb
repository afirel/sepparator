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

    context 'converts encoding independent' do
      let(:csv_string) { "test \u00A9 foo" }
      it 'converts a UTF-8 string' do
        subject
        expect(File.exists?(xls_path)).to be_true
      end
    end
  end
  context '#convert' do
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

    context 'converts encoding independent' do
      let(:csv_file) { create_temp_file_with_utf8_chars }
      let(:csv_path) { csv_file.path }

      def create_temp_file_with_utf8_chars
        tf = Tempfile.new("test_with_utf8_chars")
        tf.write "test \u00A9 foo"
        tf.close
        tf
      end

      it 'supports UTF-8 CSV files' do
        subject
        expect(File.exists?(xls_path)).to be_true
      end
    end

    it 'raises when the source file was not found' do
      expect{described_class.new.convert('/some/non/existing/file.csv', xls_path)}.to raise_error(ArgumentError, /file not found/)
    end

  end

end
