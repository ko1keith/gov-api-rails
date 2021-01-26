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
    expend_by_members_link = "https://www.ourcommons.ca/PublicDisclosure/#{doc_quarter.search('a#ctl00_lnkMemberExpenditures\\.aspx')[0].attribute('href').text}&FormatType=XML"
    expend_by_members_xml = Nokogiri::XML(URI.parse(expend_by_members_link).open).root

    start_date = expend_by_members_xml.attribute('startDate').text
    end_date = expend_by_members_xml.attribute('endDate').text

    expend_by_members_xml.css('Report').each do |report|
      constit = Constituency.find_by(name: report.css('Constituency').first.attribute('name-en').text.gsub('—', '-'))
      first_name = report.css('Member').first.attribute('firstName').text.downcase
      last_name = report.css('Member').first.attribute('lastName').text.downcase
      member = Member.find_by(first_name: first_name, last_name: last_name)

      binding.pry
    end
  end
end
