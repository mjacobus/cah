# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Addresses::IndexComponent, type: :component do
  let(:addresses) { Address.all }
  let(:congregation) do
    Congregation.create!(name: 'Some Name', circuit:)
  end

  let(:circuit) { Circuit.create!(name: 'Some name') }

  before do
    Address.create!(
      householder_name: 'John Doe',
      street_name: '123 Elm St',
      congregation:
    )
  end

  it 'renders something useful' do
    content = render_inline(described_class.new(addresses:)).to_html

    expect(content).to include(addresses.first.street_name)
  end
end
