FakeApp = Class.new(Rails::Application)
ENV['RAILS_ENV'] ||= 'test'
FakeApp.config.session_store :cookie_store, key: '_myapp_session'
FakeApp.config.eager_load = false
FakeApp.config.hosts << 'www.example.com' if FakeApp.config.respond_to?(:hosts)
FakeApp.config.root = File.dirname(__FILE__)
FakeApp.config.ci_logger.enabled = true
FakeApp.initialize!

FakeApp.routes.draw do
  resources :users
end

class UsersController < ActionController::Base
  def index
    render plain: 'hello'
  end
end
