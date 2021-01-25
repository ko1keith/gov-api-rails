require 'open-uri'
puts 'Starting Script...'
base_url = 'https://www.ourcommons.ca/ProactiveDisclosure/en/members/previous-reports'
html = URI.open(base_url)
doc = Nokogiri::HTML(html)

doc.css('.reports-previous-specific-year-container').each do |report_div|
  binding.pry
end
