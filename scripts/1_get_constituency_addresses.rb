require 'HTTParty'

html = HTTParty.get('https://www.ourcommons.ca/members/en/constituencies/addresses')
doc = Nokogiri::HTML(html)

# addresses = doc.css('row')
# puts addresses
row_elem = doc.search('.row')
puts row_elem.size
addresses = nil
row_elem.each do |row|
  col_lg_4_elems = row.css('.col-lg-4')
  addresses = col_lg_4_elems if col_lg_4_elems.size > 100
end

addresses.each do |add|
  puts add
  sleep(2)
end
