class Api::V1::SearchesController < ApplicationController
  def member
    return render json: { "error": 'only one input paramter allowed' } if member_params.keys.count > 1

    lat_long = Geocoder.search(member_params['query']).first.data.slice('lat', 'lon')
    return render json: { "error": 'no address found' }, status: 404 if lat_long.nil?

    member = RepresentSearch.new(lat_long).search_member
    render json: member
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
