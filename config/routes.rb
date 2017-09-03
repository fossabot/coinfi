Rails.application.routes.draw do
  root 'pages#home'

  get '/' => 'pages#home', as: 'home'
  get '/about' => 'pages#about'
  get '/contact' => 'pages#contact'
  get '/daily' => 'pages#daily', as: 'daily'
  get '/customize' => 'pages#customize', as: 'customize'
  #get '/thanks' => 'pages#thanks', as: 'thanks'
  # post '/subscribe'
  post '/segment' => 'pages#segment', as: 'segment'
end
