class Api::V1::SearchesController < ApplicationController
  def member
    return render json: { "error": 'only one input parameter allowed' } if member_params.keys.count > 1

    # Geocoder.search returns a one element array of type GEOCODER::Result::Nominatim, which has an attribute
    # called data, which is of type hash. So get the first and only element of the returned array, get the data hash
    # from the GEOCODER object, and get the latitute and longitude values from the 'lat' and 'lon' keys
    lat_long = Geocoder.search(member_params['address']).first.data.slice('lat', 'lon')
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
    return render json: { "error": 'only one input parameter' }, status: 400 if constituency_params.keys.count > 1
    return render json: { 'error': 'no parameters given' }, status: 400 if constituency_params.empty?

    lat_long = Geocoder.search(constituency_params['address']).first.data.slice('lat', 'lon')
    return render json: { "error": 'no address found from given address' }, status: 404 if lat_long.nil?

    constituency_json = RepresentSearch.new(lat_long).search_constituency
    return render json: { "error": 'no constituency found' }, status: 404 if constituency_json['objects'].empty?

    constituency_arr = []
    constituency_json['objects'].each do |obj|
      district_name = obj['district_name'].gsub('—', ' ').downcase
      constituency = Constituency.find_by(name: district_name)
      constituency_arr << constituency
    end
    return_constit = ConstituencySerializer.new(constituency_arr).serializable_hash.to_json
    render json: return_constit
  end

  private

  def member_params
    params.permit(:address)
  end

  def constituency_params
    params.permit(:address)
  end
end
