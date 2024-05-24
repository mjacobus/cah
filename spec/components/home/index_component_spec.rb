# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Home::IndexComponent, type: :component do
  it 'renders something useful' do
    content = render_inline(described_class.new).to_html

    expect(content).to include('Ajuda Humanitária')
  end
end
