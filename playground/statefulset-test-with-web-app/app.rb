require 'sinatra'
require 'pg'
require 'json'

set :port, 3000
set :bind, '0.0.0.0'
set :public_folder, 'public'

def db_connection
  PG.connect(
    host: 'postgres-service',
    port: 5432,
    dbname: 'notesdb',
    user: 'postgres',
    password: 'postgres'
  )
end

def init_db
  conn = db_connection
  conn.exec <<-SQL
    CREATE TABLE IF NOT EXISTS notes (
      id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      content TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
  conn.close
  puts 'Database initialized'
rescue PG::Error => e
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
  conn = db_connection
  result = conn.exec('SELECT * FROM notes ORDER BY created_at DESC')
  notes = result.map { |row| row }
  conn.close
  notes.to_json
end

post '/api/notes' do
  content_type :json
  data = JSON.parse(request.body.read)

  conn = db_connection
  result = conn.exec_params(
    'INSERT INTO notes (title, content) VALUES ($1, $2) RETURNING *',
    [data['title'], data['content']]
  )
  note = result.first
  conn.close
  status 201
  note.to_json
end

delete '/api/notes/:id' do
  conn = db_connection
  conn.exec_params('DELETE FROM notes WHERE id = $1', [params[:id]])
  conn.close
  status 204
end

get '/health' do
  content_type :json
  { status: 'healthy' }.to_json
end
