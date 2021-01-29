require 'open-uri'

def extract_info(p)
  # extract address info
  addr = {}
  p.each do |single_p|
    # mulitple p tags, find the one with "Main Office"
    next unless single_p.text.include? 'Main office'

    # main office
    array_of_texts = []
    single_p.children.map { |child| array_of_texts.append(child.text) if child.name == 'text' }
    arr = array_of_texts.map { |elem| elem.gsub("\r\n", '').strip }
    arr.each do |line|
      if line.include? '(Main office)'
        addr['street'] = line.gsub('(Main office)', '')
      elsif line.include?('Suite') || line.include?('Unit')
        addr['unit'] = line
      elsif line.include?(',') && !line.include?('Main office')
        area = line.split(',')
        addr['region'] = area[0].strip
        addr['province'] = area[1].strip
      elsif line.size == 7
        letters = 0
        numbers = 0
        line.gsub(' ', '').split('').each do |char|
          if char.match?(/[[:alpha:]]/)
            letters += 1
          else
            numbers += 1
          end
        end
        addr['postal_code'] = line if (letters == 3) && (numbers == 3)
      elsif line.include? 'Telephone'
        number = line.split(':')[1]
        addr['telephone'] = number.strip
      end
    end
  end
  addr
end

html = URI.parse('https://www.ourcommons.ca/members/en/constituencies/addresses').open
doc = Nokogiri::HTML(html)

row_elem = doc.search('.row')
puts row_elem.size
addresses = nil
row_elem.each do |row|
  col_lg_4_elems = row.css('.col-lg-4')
  addresses = col_lg_4_elems if col_lg_4_elems.size > 100
end

addresses.each do |add|
  begin
    constituency = Constituency.find_by(name: add.at('h2').text.gsub('—', ' ').gsub('-', ' ').downcase)
  rescue StandardError
    binding.pry
  end
  next unless constituency && !constituency.addresses.present?

  address_info = extract_info(add.search('p'))
  begin
    created_address = Address.new(street: address_info['street']&.downcase, unit: address_info['unit']&.downcase, region: address_info['region']&.downcase,
                                  province: address_info['province']&.downcase, postal_code: address_info['postal_code']&.downcase, telephone: address_info['telephone'])
  rescue StandardError
    binding.pry
  end
  created_address.constituency = constituency
  created_address.save
end
