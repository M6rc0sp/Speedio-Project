require_relative '../spiders/website_spider'

class WebsiteService

  def search_info(search_id, url)
    spider = WebsiteSpider.new

    begin
      informations = spider.scrape_website(search_id, url)
      $colecao.update_one({ 'search_id' => search_id }, { '$set' => informations }, :upsert => true)
    rescue StandardError => e
      puts "Erro ao salvar informações: #{e.message}"
      raise e
    ensure
      spider.quit
    end
  end

  def get_info(search_id)
    informations = $colecao.find('search_id' => search_id).first
    informations
  rescue StandardError => e
    # Lidar com a exceção, por exemplo, logar e reemitir
    puts "Erro ao obter informações: #{e.message}"
    raise e
  end
end
