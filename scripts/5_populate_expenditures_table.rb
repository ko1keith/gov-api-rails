require 'open-uri'

def iterate_cat_info(category)
  # method to iterate through category element, this element might have subcategories
  exp_arr = []
  if category.css('SubCategories').children.present?
    # if cat has subcat, iterate through its children and extract expenditures
    category.css('SubCategories').children.each do |child_cat|
      exp = extract_cat_info(child_cat)
      exp_arr << exp if exp.present?
    end
  else
    # category has no subcategory, empl salery/gifts/service contracts, no need to interate
    # through its chidren
    exp = extract_cat_info(category)
    exp_arr << exp if exp.present?
  end
  exp_arr
end

def extract_cat_info(category)
  sub_category_id_parents = {
    "01": "Employees' Salaries",
    "02": 'Service Contracts',
    "03": 'Travel',
    "04": 'Hospitality',
    "05": 'Gifts',
    "06": 'Advertising',
    "07": 'Printing',
    "08": 'Offices'
  }
  # certain values are always at n index of the children, pull directly from that position
  member_budget = category.children[0].attribute('value')&.text.to_d
  resources_by_house = category.children[1].attribute('value')&.text.to_d
  total = category.children[2].attribute('value')&.text.to_d
  arr = [member_budget, resources_by_house, total]

  # if all of the elements in the array is nil, no need to go further, return from method
  return nil if arr.all? { |elem| elem == '0'.to_d }

  if category.attribute('id').value[2].match?(/[[:alpha:]]/)
    # if char at index 2 is letter, then it is subcategory
    sub_category_name = category.attribute('name-en').text
    category_name = sub_category_id_parents[category.attribute('id').value[0..1].to_sym]
  elsif category.attribute('id').value[2].match?(/[[:digit:]]/)
    # if char at index 2 is integer, then it is category
    category_name = sub_category_id_parents[category.attribute('id').value[0..1].to_sym]
  end
  exp = Expenditure.new(
    member_budget: member_budget,
    resources_provided_by_house: resources_by_house,
    total: total,
    category: category_name,
    subcategory: sub_category_name
  )
end

puts 'Starting Script...'
base_url = 'https://www.ourcommons.ca/ProactiveDisclosure/en/members/previous-reports'
html = URI.parse(base_url).open
doc = Nokogiri::HTML(html)
previous_years_div = doc.css('.reports-previous-specific-year-container')
previous_years_div.each do |report_div|
  next if report_div.attributes['data-year'].value.split('-').include? '2012'
  next if report_div.attributes['data-year'].value.split('-').include? '2015'
  next if report_div.attributes['data-year'].value.split('-').include? '2016'
  next if report_div.attributes['data-year'].value.split('-').include? '2017'
  next if report_div.attributes['data-year'].value.split('-').include? '2018'
  next if report_div.attributes['data-year'].value.split('-').include? '2019'
  next if report_div.attributes['data-year'].value.split('-').include? '2020'

  report_div.css('.reports-previous-buttons-4').each do |quarter_report_div|
    binding.pry
    html_quarter = URI.parse("https://www.ourcommons.ca#{quarter_report_div.children[1].attribute('href').text}").open
    if quarter_report_div.children[1].attribute('href').text == '/PublicDisclosure/UnderstandingReport.aspx?Id=MER2013FY&Language=E'
      # bad link, sends to 2020 instead, so skip
      next
    end

    doc_quarter = Nokogiri::HTML(html_quarter)
    expend_by_members_link = "https://www.ourcommons.ca/PublicDisclosure/#{doc_quarter.search('a#ctl00_lnkMemberExpenditures\\.aspx')[0].attribute('href').text}&FormatType=XML"
    expend_by_members_xml = Nokogiri::XML(URI.parse(expend_by_members_link).open).root

    start_date = expend_by_members_xml.attribute('startDate').text
    end_date = expend_by_members_xml.attribute('endDate').text

    expend_by_members_xml.css('Report').each do |report|
      constit = Constituency.find_by(name: report.css('Constituency').first.attribute('name-en').text.gsub('—', '-'))
      if report.css('Member').first.attribute('status').text == 'Vacant'
        first_name = 'Vacant'
        last_name = 'Vacant'
      else
        first_name = report.css('Member').first.attribute('firstName').text.downcase
        last_name = report.css('Member').first.attribute('lastName').text.downcase
      end
      member = Member.find_by(first_name: first_name, last_name: last_name)
      count = 0
      report.css('ExpenditureCategories').children.each do |category|
        exps = iterate_cat_info(category)
        next if exps.empty?

        exps.map do |exp|
          exp.start_date = start_date
          exp.end_date = end_date
          exp.member = member
          exp.constituency = constit
        end
        count += exps.count
      end
      puts "#{count} expenditures scraped and created for #{first_name} #{last_name} between #{start_date} and #{end_date}}."
    end
  end
end
