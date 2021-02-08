class Api::V1::MembersController < ApplicationController
  def index
    member_of_p = if index_params['constituency_name'].present?
                    Member.includes(:constituency).where(constituency: { name: index_params['constituency_name'] })
                  elsif index_params.present?
                    Member.where(index_params)
                  else
                    Member.all
                  end
    return render json: { "error": 'Unable to find members' }, status: 404 if member_of_p.empty?

    mem_json = MemberSerializer.new(member_of_p).serializable_hash.to_json
    render json: mem_json
  end

  def show
    member_of_parlaiment = Member.find_by(id: show_params[:id])
    return render json: { "error": 'Unable to find members' }, status: 404 if member_of_parlaiment.empty?

    render json: member_of_parlaiment
  end

  private

  def index_params
    params.permit(:party, :first_name, :last_name, :constituency_name, :constituency_id)
  end

  def show_params
    params.permit(:id)
  end
end
