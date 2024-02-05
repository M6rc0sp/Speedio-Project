class WebsiteJob < ApplicationJob
    queue_as :default

    def perform(search_id, url)
      service = WebsiteService.new
      service.search_info(search_id, url)
    end
  end
