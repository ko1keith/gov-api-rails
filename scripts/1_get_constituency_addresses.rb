require 'HTTParty'

def is_postal_code(str)
  # check to see if string is postal code, 7 chars long, 3 Letters, 3 Numbers
end

def extract_info(p)
  # extract address info
  p.each do |single_p|
    # mulitple p tags, find the one with "Main Office"
    next unless single_p.text.include? 'Main office'

    # main office
    arr = single_p.text.strip.split("\r\n").map(&:strip)
    puts arr
  end
  {}
end

html = HTTParty.get('https://www.ourcommons.ca/members/en/constituencies/addresses')
doc = Nokogiri::HTML(html)

row_elem = doc.search('.row')
puts row_elem.size
addresses = nil
row_elem.each do |row|
  col_lg_4_elems = row.css('.col-lg-4')
  addresses = col_lg_4_elems if col_lg_4_elems.size > 100
end

addresses.each do |add|
  puts add.at('h2').text.gsub('—', '-')
  address_info = extract_info(add.search('p'))
  puts address_info
  sleep(2)
end
