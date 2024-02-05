require_relative '../services/website_service'

class WebsiteController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      render file: 'public/index.html'
    end

    def save_info
        url = params[:url]
        search_id = Digest::MD5.hexdigest(url)

        # Iniciar o processo de scraping
        WebsiteJob.perform_later(search_id, url)

        render json: { status: 'success', id: search_id, message: 'Operação iniciada com sucesso' }.to_json, status: :created
    end

    def get_info
      id = params[:id]
      service = WebsiteService.new

      begin
        # Recuperar os dados do MongoDB
        informations = service.get_info(id)

        if informations.nil? || informations.empty?
          render json: { status: 'error', message: 'Operação ainda não concluída ou ID inválido' }, status: :not_found
        else
          render json: { status: 'success', message: informations }
        end
      rescue StandardError => e
        render json: { status: 'error', message: 'Operação não encontrada' }, status: :not_found
      end
    end
  end
