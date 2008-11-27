$KCODE = 'UTF8'

require 'dm-core'
dependency "merb-assets"


use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Config.use do |c|
  c[:session_id_key] = 'forumtastic_session_id'
  c[:session_secret_key]  = 'c5363330e48ec97f891ced3fa360c5ceab8ad75c'
  c[:session_store] = 'cookie'
  c[:reload_templates] = true
  c[:compass] = {
    :stylesheets => 'app/stylesheets',
    :compiled_stylesheets => 'public/stylesheets'
  }
end

Merb::BootLoader.after_app_loads do
  DataMapper.setup(:default, "sqlite3://#{Merb.root}/config/sample.db")
end