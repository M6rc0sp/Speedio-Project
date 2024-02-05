require 'mongo'

Mongo::Logger.logger.level = ::Logger::INFO
$client = Mongo::Client.new([ENV['DB_HOST']], database: ENV['DB_NAME'])
$colecao = $client[:websites]
