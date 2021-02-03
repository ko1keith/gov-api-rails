require 'rails_helper'

RSpec.describe 'Members', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/members', headers: headers
      binding.pry
      expect(response.status).to eq(200)
      expect(response).to have_http_status(:success)
    end
    # it 'JSON body response contains expected recipe attributes' do
    #   json_response = JSON.parse(response.body)
    #   expect(hash_body.keys).to match_array(%i[id first_name last_name])
    # end
  end
end
