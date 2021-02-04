class Api::V1::SearchesController < ApplicationController
  def member
    return render json: { "error": 'only one input paramter allowed' } if member_params.keys.count > 1

    lat_long = Geocoder.search(member_params['query']).first.data.slice('lat', 'lon')
    return render json: { "error": 'no address found' }, status: 404 if lat_long.nil?

    member_json = RepresentSearch.new(lat_long).search_member
    return render json: { "error": 'no members found' }, status: 404 if member_json['objects'].empty?

    mem_arr = []
    member_json['objects'].each do |obj|
      first_name = obj['first_name'].downcase
      last_name = obj['last_name'].downcase
      mem = Member.find_by(first_name: first_name, last_name: last_name)
      mem_arr << mem
    end
    # find other info, expenditures, constituency

    render json: mem_arr
  end

  def constituency
    puts constituency_params
  end

  private

  def member_params
    params.permit(:query)
  end

  def constituency_params
    params.permit(:address, :ip_address)
  end
end
