# Speedio Project

## Introdução
Esse projeto é um webscrapper para sondar informações sobre sites enviados na requisição da API no método /save_info de forma assíncrona.
Também recupera as informações colhidas no site websimilar no banco de dados, a partir de um ID feito na requisição do método /get_info.

## Pré-requisitos
Antes de iniciar o projeto, você precisa ter o Ruby, Rails e MongoDB instalados em sua máquina. Se você ainda não os instalou, siga os passos abaixo:

1. Instale o Ruby: Você pode encontrar instruções para a instalação em [https://www.ruby-lang.org/pt/documentation/installation/](https://www.ruby-lang.org/pt/documentation/installation/)
2. Instale o Rails: Depois de instalar o Ruby, você pode instalar o Rails executando `gem install rails` no terminal.
3. Instale o MongoDB: Você pode encontrar instruções para a instalação em [https://docs.mongodb.com/manual/installation/](https://docs.mongodb.com/manual/installation/)

## Iniciando
Para iniciar o projeto, siga esses passos:

1. Clone o repositório: `git clone https://github.com/M6rc0sp/Speedio-Project.git`
2. Instale as dependências: `bundle install`
3. Copie o arquivo `template.env` para um novo arquivo chamado `.env` e preencha as variáveis de ambiente conforme necessário.
4. Verifique as configurações do seu Banco no arquivo `.env` e descomente o driver para seu navegador e sistema operacional escolhido.
5. Se você estiver usando Linux e o driver não abrir, execute o seguinte comando no terminal: `chmod +x ./selenium_drivers/edgedriver/msedgedriver` (ou o driver que você escolheu).
6. Execute a API: `rails server`
7. Acesse o local onde a aplicação está rodando, geralmente: [http://127.0.0.1:3000](http://127.0.0.1:3000).
8. A exibição na página servida pelo rails aqui é só para teste, o alert não consegue exibir todos os campos que foram capturados. No desenvolvimento usei do insomnia, mas criei esse html para uma facilitação nos testes.

## Rotas disponíveis

- **POST /salve_info**: Recebe uma `url` como parâmetro. Gera um `search_id` a partir da URL e inicia uma operação assíncrona para buscar informações sobre o site. Retorna um status HTTP 201 e um corpo de resposta JSON indicando sucesso.

- **POST /get_info/:id**: Recebe um `id` como parâmetro. Tenta recuperar as informações associadas ao `id` fornecido. Se as informações forem encontradas, retorna um status HTTP 200 e um corpo de resposta JSON com as informações. Se as informações não forem encontradas ou estiverem vazias, retorna um status HTTP 404 e um corpo de resposta JSON indicando erro.