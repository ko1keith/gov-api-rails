require 'rails_helper'

RSpec.describe 'Expenditures', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/api/v1/expenditures', headers: headers
      expect(response).to have_http_status(:success)
    end
  end

  it 'JSON body response contains expected expenditure attributes' do
    headers = { 'ACCEPT' => 'application/json' }
    get '/api/v1/expenditures', headers: headers
    json_response = JSON.parse(response.body)

    expect(response).to have_http_status(:success)
    expect(json_response['data'][0]['attributes'].keys).to match_array(%w[category subcategory start_date
                                                                          end_date member_budget resources_provided_by_house total party member])
  end
end
