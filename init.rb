require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare :redmine_model_dependencies do
  require_dependency 'project'
  require_dependency 'user'
end

Redmine::Plugin.register :redmine_gollum_wiki do
  name 'Redmine Gollumn plugin'
  author 'Kang-min Liu <gugod@gugod.org>'
  description 'A gollum plugin for redmine'
  version '0.0.1'
  url 'https://github.com/gugod/redmine-gollumn/'
  # author_url 'http://gugod.org'

  requires_redmine :version_or_higher => '1.1.0'

  project_module :gollum_wiki do
    permission :view_gollum_wiki,   :gollum => [:index, :show]
    permission :add_gollum_wiki,    :gollum => [:new, :create]
    permission :edit_gollum_wiki,   :gollum => [:edit, :update]
    permission :delete_gollum_wiki, :gollum => [:destroy]
  end

  menu :project_menu, :gollum, { :controller => :gollum, :action => :index }, :caption => 'Gollum Wiki', :before => :wiki, :param => :project_id
end

Redmine::Activity.map do |activity|
  activity.register :gollum_wiki
end
