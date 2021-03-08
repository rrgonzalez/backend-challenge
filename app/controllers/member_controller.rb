class MemberController < ApplicationController

  before_action :set_member, only: [:show, :add_friend]

  def create
    @member = Member.new(
      name: params[:name],
      website_url: params[:website_url],
      friends: [],
      friends_count: 0
    )

    # Shorten URL
    @member.website_short_url = ShortUrlController.short_url(long_url: @member.website_url)

    # Crawl h1-h3 headings from member website
    heading_strs = CrawlerController.crawl_headings(@member.website_url)

    @member.headings = build_headings(heading_strs, @member)

    res = @member.save!

    if res
      render json: @member, status: 201
    else
      @err = { 'message' => 'Error creating the Member' }
      render json: @err, status: 500
    end
  end

  def index
    @members = Member.only(:name, :website_short_url, :friends_count)

    render json: @members
  end

  def show
    @ext_member = Hash.new
    @ext_member[:name] = @member.name
    @ext_member[:website_url] = @member.website_url
    @ext_member[:website_short_url] = @member.website_short_url

    @ext_member[:headings] = []

    @member.headings.each do |h|
      @ext_member[:headings] << h.pretty_print
    end

    @ext_member[:friends_pages] = []
    @member.friends.each do |f|
      @ext_member[:friends_pages] << request.base_url + '/' + f.id
    end

    render json: @ext_member
  end

  def add_friend
    render '{ "message":"Param friend_id is mandatory" }', status: 400 unless params.key?(:friend_id)

    begin
      friend = Member.find(params[:friend_id])
    rescue Mongoid::Errors::DocumentNotFound
      render '{ "message":"Friend member not found" }', status: 404
      return
    end

    @member.friends << friend
    @member.friends_count = @member.friends.count

    res = @member.save!

    friend.friends << @member
    friend.friends_count = friend.friends.count
    friend.save!

    if res
      render json: @member, status: 201
    else
      @err = { 'message' => 'Error adding the Friend' }
      render json: @err, status: 500
    end
  end

  def search_closest_expert
    terms = params[:terms]

    target_hashed_terms = []
    terms.each do |term|
      target_hashed_terms << term.to_sym
    end

    result = SearchExpertController.search_closest_expert(@member, target_hashed_terms)

    if result.blank?
      render json: {"message": "No expert found"}, status: 404
    else
      render json: {"path_to_expert": result}, status: 200
    end
  end

  private

  def build_headings(heading_strs, member)
    Rails.logger.info heading_strs

    headings = []

    # Create the Heading document for each found heading
    heading_strs.each do |heading_str|
      terms = heading_str.split
      # Rails.logger.info terms
      hashed_terms = Set.new

      # By converting the string to symbol it is being hashed
      # Symbols can be compared faster than strings, this is useful for expert search
      terms.each do |term|
        term = term.gsub(/[^0-9a-zA-Z]/i, '')
        hashed_terms.add(term.to_sym)
      end

      heading = Heading.create!(member: member, pretty_print: heading_str, hashed_terms: hashed_terms)
      headings << heading
    end

    headings
  end

  def set_member
    @member = Member.find(params[:id])
  end

end
