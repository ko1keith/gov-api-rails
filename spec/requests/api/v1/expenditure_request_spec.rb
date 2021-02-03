require 'rails-helper'

RSpec.describe 'Expenditures', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/expenditures', headers: headers
      expect(response).to have_http_status(:success)
    end
  end
end
