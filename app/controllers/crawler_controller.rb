require 'meta_inspector'

class CrawlerController

  # Crawl headings (h1-h3) from page using classic BFS
  def self.crawl_headings(url)

    Rails.logger.info "STARTED crawl_headings on #{url}"

    queue = []
    visited = []
    headings = Set.new

    page = MetaInspector.new(url,
                             download_images: false,
                             allow_redirections: false,
                             connection_timeout: 10,
                             read_timeout: 30,
                             retries: 4)

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
                                  link.include?('?') ||
                                  visited.include?(link) ||
                                  queue.include?(link)
        end

      rescue MetaInspector::RequestError,
             MetaInspector::ParserError,
             MetaInspector::TimeoutError
        Rails.logger.error "Error crawling page #{url}"
      end

    end

    Rails.logger.info "Found #{headings.length} headings"
    Rails.logger.info "FINISHED crawl_headings"

    headings.to_a
  end

end
