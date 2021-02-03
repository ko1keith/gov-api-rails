require 'rails_helper'

RSpec.describe 'Members', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/members', headers: headers
      expect(response).to have_http_status(:success)
    end

    it 'JSON body response contains expected member attributes' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/members', headers: headers
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json_response['data'][0]['attributes'].keys).to match_array(%w[email first_name last_name
                                                                            website party constituency])
    end

    it 'JSON body response returns only members of parlaiment from one party' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/members', params: { party: 'Liberal' }, headers: headers
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      json_response['data'].each do |mem|
        expect(mem['attributes']['party']).to eq('Liberal')
      end
    end

    it 'JSON response returns proper error status code and error message' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/members/', params: { "party": 'not a party', format: :json }, headers: headers
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(404)
      expect(json_response.keys).to match_array(['error'])
    end
  end
end
