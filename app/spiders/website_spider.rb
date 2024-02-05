require 'selenium-webdriver'
require 'nokogiri'

class WebsiteSpider
  def initialize
    # Configuração do Selenium
    Selenium::WebDriver::Chrome::Service.driver_path = ENV['DRIVER_PATH']
    @driver = Selenium::WebDriver.for ENV['BROWSER'].to_sym
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  end

  def scrape_website(url)
    informations = {}

    begin
      @driver.navigate.to 'https://www.similarweb.com/website/' + url

      # Verificar o nome do site
      site = @wait.until{ @driver.find_element(:class, 'wa-overview__title') }

      # Verificar a categoria do site
      category = @wait.until{ @driver.find_element(:class, 'app-company-info__link') }

      # Verificar se o ranking subiu ou desceu
      ranking_change_container = @wait.until{ @driver.find_element(:css, '.wa-rank-list__value-container') }
      classification = ranking_change_container.find_element(:class, 'wa-rank-list__value')

      begin
        ranking_change_element = ranking_change_container.find_element(:class, 'app-parameter-change')
      if ranking_change_element.attribute('class').include? '--up'
        ranking_change = '+'
      elsif ranking_change_element.attribute('class').include? '--down'
        ranking_change = '-'
      end
        ranking_change_value = ranking_change_element.text
      rescue Selenium::WebDriver::Error::NoSuchElementError
        ranking_change = '='
        ranking_change_value = ''
      end

      ranking_last_change = ranking_change + ranking_change_value

      begin
        average_visit_duration = @wait.until{ @driver.find_element(:css, '[data-test="avg-visit-duration"] + .engagement-list__item-value').text }
      rescue Selenium::WebDriver::Error::NoSuchElementError
        average_visit_duration = 'N/A'
      end

      begin
        total_visits = @wait.until{ @driver.find_element(:css, '[data-test="total-visits"] + .engagement-list__item-value').text }
      rescue Selenium::WebDriver::Error::NoSuchElementError
        total_visits = 'N/A'
      end

      begin
        bounce_rate = @wait.until{ @driver.find_element(:css, '[data-test="bounce-rate"] + .engagement-list__item-value').text }
      rescue Selenium::WebDriver::Error::NoSuchElementError
        bounce_rate = 'N/A'
      end

      begin
        pages_per_visit = @wait.until{ @driver.find_element(:css, '[data-test="pages-per-visit"] + .engagement-list__item-value').text }
      rescue Selenium::WebDriver::Error::NoSuchElementError
        pages_per_visit = 'N/A'
      end

      begin
        # Obter todos os elementos que representam os países
        country_elements = @wait.until{ @driver.find_elements(:css, '.wa-geography__country-name') }
        top_countries = country_elements.map(&:text)
      rescue Selenium::WebDriver::Error::NoSuchElementError
        top_countries = ['N/A']
      end

      begin
        # Encontrar os elementos que contêm os valores da distribuição por gênero
        gender_legend_items = @wait.until { @driver.find_elements(:css, '.wa-demographics__gender-legend-item') }

        gender_distribution = {}

        gender_legend_items.each do |item|
          title = item.find_element(:css, '.wa-demographics__gender-legend-item-title').text
          value = item.find_element(:css, '.wa-demographics__gender-legend-item-value').text
          gender_distribution[title.downcase.to_sym] = value
        end
      rescue Selenium::WebDriver::Error::NoSuchElementError
          gender_distribution = { female: 'N/A', male: 'N/A' }
      end

      begin
        # Encontrar o elemento que contém a distribuição por idade
        age_chart_element = @wait.until { @driver.find_element(:css, '.wa-demographics__age-chart') }

        # Extrair o HTML dentro desse elemento
        age_chart_html = age_chart_element.attribute('innerHTML')

        # Usar Nokogiri para analisar o HTML
        doc = Nokogiri::HTML(age_chart_html)

        # Encontrar todos os elementos que contêm os valores da distribuição por idade
        age_values_elements = doc.css('.wa-demographics__age-data-label')

        # Encontrar todos os elementos que contêm as faixas etárias
        age_ranges_elements = doc.css('.highcharts-xaxis-labels text')

        # Criar um hash para armazenar os resultados da distribuição por idade
        age_distribution = {}

        # Iterar sobre os elementos e extrair faixas etárias e porcentagens
        age_values_elements.each_with_index do |element, index|
          age_range = age_ranges_elements[index].text.strip
          age_percentage = element.text.strip

          # Salvar os resultados no hash
          age_distribution[age_range] = age_percentage
        end
      rescue Selenium::WebDriver::Error::NoSuchElementError
          # Lide com a exceção, se necessário
          age_distribution = { 'N/A' => 'N/A' }
      end

      begin
          company_info_element = @wait.until { @driver.find_element(:css, '.app-company-info') }
          company_info_html = company_info_element.attribute('innerHTML')
          company_doc = Nokogiri::HTML(company_info_html)

          company = company_doc.css('.app-company-info__list-item--title:contains("Company") + dd').text.strip
          year_founded = company_doc.css('.app-company-info__list-item--title:contains("Year Founded") + dd').text.strip
          hq = company_doc.css('.app-company-info__list-item--title:contains("HQ") + dd').text.strip

          company_info = {
            company: company,
            year_founded: year_founded,
            hq: hq
          }
      rescue Selenium::WebDriver::Error::NoSuchElementError
          company_info = { company: 'N/A', year_founded: 'N/A', hq: 'N/A' }
      end

      informations = {
        'search_id' => search_id,
        'classification' => classification.text.delete('#'),
        'site' => site.text,
        'category' => category.text.split('>').last.strip,
        'ranking_last_change' => ranking_last_change,
        'average_visit_duration' => average_visit_duration,
        'total_visits' => total_visits,
        'bounce_rate' => bounce_rate,
        'pages_per_visit' => pages_per_visit,
        'top_countries' => top_countries,
        'gender_distribution' => gender_distribution,
        'age_distribution' => age_distribution,
        'company' => company_info[:company],
        'year_founded' => company_info[:year_founded],
        'hq' => company_info[:hq]
      }
    rescue StandardError => e
      puts "Erro durante a busca de informações: #{e.message}"
      raise e
    end
  end

  def quit
    @driver.quit
  end
end
