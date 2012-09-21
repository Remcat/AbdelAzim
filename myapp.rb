# myapp.rb
require 'sinatra'
#require "dm-core"
#for using auto_migrate!
#require "dm-migrations"
#require "digest/sha1"
#require 'rack-flash'
#require "sinatra-authentication"

#use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
#use Rack::Flash

configure do
  set :username,'Bond'
  set :token,'shakenN0tstirr3d'
  set :password,'007'
  enable :sessions
end

helpers do
  def link_to(url,text=url,opts={})
    attributes = ""
    opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
    "<a href=\"#{url}\" #{attributes} >#{text}</a>"
  end
  def admin? ; request.cookies[settings.username] == settings.token ; end
  def protected! ; halt [ 401, haml(:error) ] unless admin? ; end
end

get '/' do
  session["user"] ||= nil
  @name = session["user"] || 'World'
  haml :index
end

post '/' do
  @name = params[:message]
  session["user"] = @name
  haml :index
end

get('/admin'){ haml :admin }

post '/login' do
  if params['username']==settings.username&&params['password']==settings.password
    response.set_cookie(settings.username,settings.token) 
    redirect "/private"
  else
    "Username or Password incorrect"
  end
end

get('/logout'){ session["user"] = nil; response.set_cookie(settings.username, false) ; redirect '/' }

get '/public' do
  haml :pub
end

get '/private' do
  protected!
  haml :priv
end

get '/form' do
  haml :form
end 

get '/:name' do |n|
  @name = n
  haml :index
end
