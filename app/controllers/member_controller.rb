class MemberController < ApplicationController

  def create
    @member = Member.new(
      name: params[:name],
      website_url: params[:website_url]
    )

    res = @member.save!

    if res
      render json: @member, status: 201
    else
      @err = { 'message' => 'Error creating the Member' }
      render json: @err, status: 500
    end
  end

  def index
  end

  def show
  end

  def add_friend
  end

end
