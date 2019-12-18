require 'sinatra'
require 'sqlite3'

# $db = SQLite3::Database.open('dogmeet.sqlite3')
# #the '$' makes it a global variable
# set :port, 3000
# # RULE 1: HAVE FUN!!!
#
# $db.execute(%(
#   CREATE TABLE users(
#     name TEXT,
#     email TEXT,
#     password TEXT
#     );
#   ))
#
#   $db.execute(%(
#     CREATE TABLE dogs(
#       name TEXT,
#       breed TEXT
#       );
#     ))
#
# def start
#   # open a database file#
#   $db = SQLite3::Database.open('dogmeet.sqlite3')
#   # check to see if any tables exist in this databases
#   results = db.execute('SELECT * FROM users;')
#   # if tables exist, then this is a previously installed DB
#   unless results == []
#     $db.execute(%(
#       CREATE TABLE users(
#         name TEXT,
#         email TEXT,
#         password TEXT
#         );
#       ))
#
#       $db.execute(%(
#         CREATE TABLE dogs(
#           name TEXT,
#           breed TEXT
#           );
#         ))
#     end
# end
#

set :port, 3000

enable :sessions
def start
  # open a database file
  $db = SQLite3::Database.open('dogmeet.sqlite3')
  results = $db.table_info('users')
  # check if there are any results
  unless results.any?
    # create tables if there are no results from the query
    $db.execute(%(
       CREATE TABLE users(
          name TEXT,
          email TEXT,
          password TEXT
       );
    ))
    $db.execute(%(
       CREATE TABLE dogs(
         name TEXT,
         breed TEXT
       );
    ))
  end
end

get '/' do
 erb :home

end
get '/signup' do
  erb :signup

end

post '/signup' do
  user = params["user"]
  $db.execute(%(
    INSERT INTO users (name, email, password)
    VALUES ('#{user['name']}','#{user['email']}', '#{user['password']}');
    ))
end

get '/profile' do
  erb :profile
end

get '/login' do
  erb :login
end

post '/login' do
  data = nil
  given_password = params[:password]
result = $db.execute(%(
  SELECT email, password FROM users WHERE email = '#{params[:email]}';
  )) { |row| data = row; break;}
  return '<h1> Invalid email or passord</h1>' if !data
  if given_password == data[1]
    return'<h1> You are logged in! </h1>'
  end
end

get '/logout' do
  session[:user_id] = nil
  #use the session hash and look into the 'id' key and set it to 'nil'
end
start

get '/' do
  erb :home

end

get '/signup' do
  erb :signup

end

post '/signup' do

end
