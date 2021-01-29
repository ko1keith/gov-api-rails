require 'HTTParty'

xml = HTTParty.get('https://www.ourcommons.ca/members/en/constituencies/xml')

doc = Nokogiri::XML(xml.to_s).root

doc.css('Constituency').each do |constituency|
  constit = Constituency.find_by(name: constituency.at('Name').text.gsub('—', ' '))
  next if constit

  Constituency.create(name: constituency.at('Name').text.gsub('—', ' ').gsub('-', ' ').downcase,
                      region: constituency.at('ProvinceTerritoryName').text.downcase,
                      current_caucus: constituency.at('CurrentCaucusShortName').text.downcase)
end
