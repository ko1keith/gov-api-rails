class Api::V1::MembersController < ApplicationController
  def index
    members_of_parlaiment = if show_params
                              Member.where(show_params)
                            else
                              Member.all
                            end

    render json: members_of_parlaiment
  end

  def show
    binding.pry
    member_of_parlaiment = Member.find_by(id: show_params[:id])
    render json: member_of_parlaiment
  end

  private

  def show_params
    params.permit(:id, :first_name, :last_name, :party, :constituency_district_number)
  end
end
