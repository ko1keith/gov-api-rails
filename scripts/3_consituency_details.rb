require 'open-uri'
puts 'Starting Script...'

html = URI.parse('https://www.ourcommons.ca/members/en/constituencies/').open
doc = Nokogiri::HTML(html)

constituencies = Constituency.all

doc.css('.mip-constituency-tile').each do |tile|
  const_name = tile.css('.mip-constituency-name').text.gsub('—', ' ').gsub('-', ' ').downcase
  constituency = constituencies.find_by(name: const_name)
  next unless constituency && !constituency.district_number.present?

  # follow link, get new html
  html_constit = URI.parse('https://www.ourcommons.ca' + tile.attributes['href'].text).open
  doc_constit = Nokogiri::HTML(html_constit)
  elections_url = doc_constit.search('.col-5')[1].children[1].attribute('href').text
  html_elections = URI.parse(elections_url).open
  doc_elections = Nokogiri::HTML(html_elections)
  profilelist_element = doc_elections.search('.profilelist').children
  profilelist_element.each_with_index do |child, i|
    if child.text == 'Electoral district number:' && constituency.district_number.nil?
      puts("Updating #{constituency.name} district_number...")
      constituency.update(district_number: profilelist_element[i + 2].text.to_i)
    elsif child.text == 'Region:' && constituency.region.nil?
      puts("Updating #{constituency.name} region...")
      constituency.update(region: profilelist_element[i + 2].text)
    elsif child.text == 'Area:' && constituency.area.nil?
      puts("Updating #{constituency.name} area...")
      constituency.update(area: profilelist_element[i + 2].text)
    elsif child.text == 'Population**:' && constituency.population.nil?
      puts("Updating #{constituency.name} population")
      constituency.update(population: profilelist_element[i + 2].text.gsub(',', '').to_i)
    elsif child.text == 'Number of electors on list****:' && constituency.number_of_electors.nil?
      puts("Updating #{constituency.name} electors")
      constituency.update(number_of_electors: profilelist_element[i + 2].text.gsub(',', '').to_i)
    end
  end
end

puts 'Script finished'
