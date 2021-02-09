require 'httparty'
class RepresentSearch
  def initialize(lat_long)
    @lat_long = lat_long
    @point = "#{lat_long['lat']}%2C#{lat_long['lon']}"
  end

  def search_member
    base_url = "https://represent.opennorth.ca/representatives/house-of-commons/?point=#{@point}"
    response = HTTParty.get(base_url, body: { point: @point })
    json_response = JSON.parse(response.body)
  end

  def search_constituency
    base_url = "https://represent.opennorth.ca/representatives/house-of-commons/?point=#{@point}"
  end
end
