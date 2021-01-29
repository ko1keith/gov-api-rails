class Api::V1::ExpendituresController < ApplicationController
  def index
    expenditures = if index_params
                     Expenditure.where(index_params)
                   else
                     Expenditure.all
                   end
    render json: expenditures
  end

  private

  def show_params; end

  def index_params
    params.permit(:id, :start_data, :end_date, :member_first_name, :member_last_name, :party, :constituency)
  end
end
