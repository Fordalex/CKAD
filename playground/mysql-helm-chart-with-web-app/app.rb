require 'sinatra'
require 'mysql2'
require 'json'

set :port, 3000
set :bind, '0.0.0.0'
set :public_folder, 'public'

def db_connection
  Mysql2::Client.new(
    host: 'mysql',
    port: 3306,
    database: 'testdb',
    username: 'testuser',
    password: 'testpass123'
  )
end

def init_db
  client = db_connection
  client.query(<<-SQL)
    CREATE TABLE IF NOT EXISTS notes (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
  client.close
  puts 'Database initialized'
rescue Mysql2::Error => e
  puts "DB init error: #{e.message}"
end

configure do
  init_db
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/api/notes' do
  content_type :json
  client = db_connection
  result = client.query('SELECT * FROM notes ORDER BY created_at DESC')
  notes = result.to_a
  client.close
  notes.to_json
end

post '/api/notes' do
  content_type :json
  data = JSON.parse(request.body.read)

  client = db_connection
  statement = client.prepare('INSERT INTO notes (title, content) VALUES (?, ?)')
  statement.execute(data['title'], data['content'])

  id = client.last_id
  result = client.query("SELECT * FROM notes WHERE id = #{id}")
  note = result.first
  client.close

  status 201
  note.to_json
end

delete '/api/notes/:id' do
  client = db_connection
  statement = client.prepare('DELETE FROM notes WHERE id = ?')
  statement.execute(params[:id])
  client.close
  status 204
end

get '/health' do
  content_type :json
  { status: 'healthy' }.to_json
end
