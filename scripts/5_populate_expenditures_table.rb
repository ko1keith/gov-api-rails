require 'open-uri'
puts 'Starting Script...'
base_url = 'https://www.ourcommons.ca/ProactiveDisclosure/en/members/previous-reports'
html = URI.parse(base_url).open
doc = Nokogiri::HTML(html)
previous_years_div = doc.css('.reports-previous-specific-year-container')
previous_years_div.each do |report_div|
  year = report_div.attribute('data-year').text
  reports_button_divs = report_div.css('.reports-previous-buttons-4')

  reports_button_divs.each do |quarter_report_div|
    html_quarter = URI.parse("https://www.ourcommons.ca#{quarter_report_div.children[1].attribute('href').text}").open
    doc_quarter = Nokogiri::HTML(html_quarter)
    summary_link = "https://www.ourcommons.ca/PublicDisclosure/#{doc_quarter.search('a#ctl00_lnkSummaryExpenditures\\.aspx')[0].attribute('href').text}&FormatType=XML"
    expend_by_members_link = "https://www.ourcommons.ca/PublicDisclosure/#{doc_quarter.search('a#ctl00_lnkMemberExpenditures\\.aspx')[0].attribute('href').text}&FormatType=XML"
    summary_xml = Nokogiri::XML(URI.parse(summary_link).open).root
    expend_by_members_xml = Nokogiri::XML(URI.parse(expend_by_members_link).open).root

    binding.pry
  end
end
