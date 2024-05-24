require 'rails_helper'

RSpec.describe AddressCsvImportService do
  subject(:service) { described_class.new }

  describe '#import_csv' do
    # private gist of spec/fixture/csv_import_sample.csv
    # Kida of an integration test, for now
    let(:url) { 'https://gist.githubusercontent.com/mjacobus/5a7a03ac3ea34f110f8767714b01ccfc/raw/00c0efafda47eab3626e63b3a0236b2a523ccf29/csv_import_sample.csv' }

    let(:import) { service.import_csv(url:) }
    let(:addresses) { Address.all }
    let(:circuits) { Circuit.all }
    let(:congregations) { Congregation.all }

    before do
      allow(HTTParty).to receive(:get).with(url).and_return(
        double(body: File.read("#{Rails.root}/spec/fixtures/csv_import_sample.csv"))
      )
      import
    end

    it 'imports circuits' do
      expect(circuits.count).to eq(2)
      expect(circuits.map(&:name).sort).to eq(%w[C-01 C-02])
    end

    it 'imports postal_code' do
      expect(addresses.map(&:postal_code)).to eq(%w[
                                                   93600-300
                                                   93600-400
                                                   93600-500
                                                   93600-600
                                                 ])
    end

    it 'imports congregations' do
      expect(congregations.count).to eq(3)
      expect(congregations.map(&:name)).to eq(%w[Cong-1 Cong-2 Cong-1])
    end

    it 'imports names' do
      expect(addresses.count).to eq(4)
      expect(addresses.map(&:householder_name).sort).to eq(%w[
        Maria
        João
        Pablo
        Outro
      ].sort)
    end

    it 'imports neighboarhoods' do
      expect(addresses.map(&:neighborhood).sort).to eq([
        'centro',
        'centro',
        'centro',
        'bela vista'
      ].sort)
    end

    it 'imports householder phone' do
      expect(addresses.map(&:phone_number)).to eq(%w[
        1234
        1234
        1234
        4324
      ].sort)
    end

    it 'imports street name' do
      expect(addresses.map(&:street_name)).to eq([
        'rua dos bobos',
        'rua dos bobos',
        'rua dos espertos',
        'rua dos espertos'
      ].sort)
    end

    it 'imports complement' do
      expect(addresses.map(&:complement)).to eq(%w[
        complemento1
        complemento2
        complemento3
        complemento4
      ].sort)
    end

    it 'imports valid latitudes' do
      expect(addresses.map(&:latitude)).to eq([
        -29.123.to_d,
        -29.123.to_d,
        -29.123.to_d,
        nil
      ].to_a)
    end

    it 'imports valid longitudes' do
      expect(addresses.map(&:longitude)).to eq([
        59.456.to_d,
        59.456.to_d,
        59.456.to_d,
        nil
      ].to_a)
    end
  end
end
