class MemberController < ApplicationController

  before_action :set_member, only: [:show, :add_friend]

  def create
    @member = Member.new(
      name: params[:name],
      website_url: params[:website_url],
      friends: []
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
  end

  def show
  end

  def add_friend
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
