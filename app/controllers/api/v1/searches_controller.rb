class Api::V1::SearchesController < ApplicationController
  def member
    return render json: { "error": 'only one input parameter allowed' } if member_params.keys.count > 1

    # Geocoder.search returns a one element array of type GEOCODER::Result::Nominatim, which has an attribute
    # called data, which is of type hash. So get the first and only element of the returned array, get the data hash
    # from the GEOCODER object, and get the latitute and longitude values from the 'lat' and 'lon' keys
    lat_long = Geocoder.search(member_params['point']).first.data.slice('lat', 'lon')
    return render json: { "error": 'no address found' }, status: 404 if lat_long.nil?

    member_json = RepresentSearch.new(lat_long).search_member
    return render json: { "error": 'no members found from given address' }, status: 404 if member_json['objects'].empty?

    mem_arr = []
    member_json['objects'].each do |obj|
      first_name = obj['first_name'].split(' ')[0].downcase
      last_name = obj['last_name'].downcase
      mem = Member.find_by(first_name: first_name, last_name: last_name)
      mem_arr << mem
    end
    # only one member should be returned
    return_mem = MemberSerializer.new(mem_arr).serializable_hash.to_json
    render json: return_mem
  end

  def constituency
    return render json: { "error": 'only one input parameter allowed' } if constituency_params.keys.count > 1

    if constituency_params['address']
      lat_long = Geocoder.search(constituency_params['address']).first.data.slice('lat', 'lon')
    elsif consituency_params['ip_address']
      lat_long = Geocoder.search(constituency_params['ip_address']).first.data.slice('lat', 'lon')

    end
    binding.pry
    puts constituency_params
  end

  private

  def member_params
    params.permit(:point)
  end

  def constituency_params
    params.permit(:address, :ip_address)
  end
end
