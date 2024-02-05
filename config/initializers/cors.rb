Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://127.0.0.1:3000' # ou '*'
  
      resource '/salve_info',
        headers: :any,
        methods: [:post],
        credentials: true
    end
  end
  