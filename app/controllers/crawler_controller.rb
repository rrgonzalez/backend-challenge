class CrawlerController

  # Crawl headings (h1-h3) from page using classic BFS
  def self.crawl_headings(url)
    Rails.logger.info "STARTED crawl_headings on #{url}"

    queue = []
    visited = []
    headings = []

    page = MetaInspector.new(url,
                             download_images: false,
                             allow_redirections: false,
                             connection_timeout: 10,
                             read_timeout: 10,
                             retries: 3)

    queue.push(page.url)

    while queue.any?
      url = queue.pop
      visited.push(url)

      begin
        page.h1.each do |h|
          headings << h
        end

        page.h2.each do |h|
          headings << h
        end

        page.h3.each do |h|
          headings << h
        end

        page.links.internal.each do |link|
          queue.push(link) unless link.include?('#') ||       # Exclude anchor links
                                  visited.include?(link) ||
                                  queue.include?(link)
        end

      rescue MetaInspector::ParserError
        Rails.logger.error "Error crawling page #{url}"
      end

    end

    Rails.logger.info "Found #{headings.length} headings"
    Rails.logger.info "FINISHED crawl_headings on #{url}"

    headings
  end

end
