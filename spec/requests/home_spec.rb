require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    xit 'returns 200' do
      get root_path

      expect(response).to have_http_status(200)
    end
  end
end
