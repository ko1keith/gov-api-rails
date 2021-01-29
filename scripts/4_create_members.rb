require 'open-uri'
puts 'Starting Script...'
base_url = 'https://www.ourcommons.ca'
search_url = 'https://www.ourcommons.ca/members/en/search/'
html = URI.parse(search_url).open
doc = Nokogiri::HTML(html)

doc.css('.ce-mip-mp-tile').each_with_index do |tile, count|
  puts "Count: #{count}"
  html = URI.parse(base_url + tile.attribute('href').text).open
  member_doc = Nokogiri::HTML(html)
  name = member_doc.css('h1').text.gsub('The', '').gsub('Honourable', '').split(' ')

  member = Member.find_by(first_name: name.first.downcase, last_name: name.last.downcase)
  next if member

  overview = member_doc.css('.ce-mip-overview')[0].children.at_css('dl').children
  political_affiliation = overview.css('.mip-mp-profile-caucus').text

  constituency_name = overview.search('a').text.gsub('—', ' ').downcase
  constituencies = Constituency.all
  constituency = constituencies.find_by(name: constituency_name)
  next unless constituency

  contact_card = member_doc.at_css('div#contact').css('.container').children
  email = ''
  website = ''
  contact_card.each_with_index do |child, i|
    if child.text == 'Email'
      email = contact_card[i + 2].text
    elsif child.text == 'Website'
      website = contact_card[i + 2].text
    end
  end
  puts "Creating new member: #{name[0]} #{name[1]}.... "
  puts "Party: #{political_affiliation}"
  puts "email: #{email}"
  puts "website: #{website}"
  puts '================'

  member = Member.new(first_name: name[0].downcase, last_name: name[1].downcase, party: political_affiliation.downcase, email: email.downcase,
                      website: website.downcase)
  member.constituency = constituency
  member.save
end
