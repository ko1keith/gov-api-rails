class Api::V1::ExpendituresController < ApplicationController
  def index
    search_params = []
    limit = 1000
    limit = index_params['limit'] if index_params['limit']
    if index_params
      index_params.each do |param|
        if param[0] == 'before_date'
          query = "start_date < '#{param[1].to_date}'"
          search_params << query
        elsif param[0] == 'after_date'
          query = "start_date > '#{param[1].to_date}'"
          search_params << query
        elsif param[0] == 'start_date'
          query = "start_date = '#{param[1].to_date}'"
          search_params << query
        elsif param[0] == 'end_date'
          query = "end_date = '#{param[1].to_date}'"
          search_params << query
        elsif param[0] == 'party'
          query = "party = '#{param[1].downcase}'"
          search_params << query
        end
      end
      query_string = ''
      search_params.each do |search|
        query_string += search + ' and '
      end
      # remove last 5 characters from queary string
      query_string = query_string[0..-6]
      if index_params['member_first_name'] && index_params['member_last_name']
        exps = Expenditure.includes(:member).where(member: { first_name: index_params['member_first_name'].downcase,
                                                             last_name: index_params['member_last_name'].downcase }).where(query_string).limit(limit)
      elsif index_params['cinstituency'] == 'constituency'
        exps = Expenditure.includes(:constituency).where(constituency: { name: index_params['constituency'].downcase }).where(query_string).limit(limit)
      else
        exps = Expenditure.where(query_string)
      end
    else
      exps = Expenditures.all
    end
    render json: exps
  end

  private

  def show_params; end

  def index_params
    params.permit(:id, :start_date, :end_date, :member_first_name, :member_last_name, :party, :constituency,
                  :before_date, :after_date, :limit, :total)
  end
end
