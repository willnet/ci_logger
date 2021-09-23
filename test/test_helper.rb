lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bundler/setup'
require 'rails'
require 'action_controller/railtie'
require 'ci_logger'
require_relative './dummy/fake_app.rb'
require 'minitest/autorun'
require 'rspec/rails'

