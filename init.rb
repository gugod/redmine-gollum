require 'grit'
require 'gollum'
require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare :redmine_model_dependencies do
  require_dependency 'project'
  require_dependency 'user'
  require_dependency 'projects_helper'
  require_dependency 'gollum_projects_helper_patch'
  require_dependency 'projects_controller'
  require_dependency 'gollum_projects_controller_patch'
end

Dispatcher.to_prepare :redmine_gollum do
  # project model should be patched before projects controller
  Project.send(:include, GollumProjectModelPatch) unless Project.included_modules.include?(GollumProjectModelPatch)
  ProjectsController.send(:include, GollumProjectsControllerPatch) unless ProjectsController.included_modules.include?(GollumProjectsControllerPatch)
  ProjectsHelper.send(:include, GollumProjectsHelperPatch) unless ProjectsHelper.included_modules.include?(GollumProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_gollum do
  name 'Redmine Gollumn plugin'
  author 'Kang-min Liu <gugod@gugod.org>'
  description 'A gollum plugin for redmine'
  version '0.0.3' +
          '-development'
  url 'https://github.com/gugod/redmine-gollumn/'
  author_url 'http://gugod.org'

  requires_redmine :version_or_higher => '1.1.0'

  settings :default => {
                       :gollum_base_path => Pathname.new(Rails.root + "gollum")
                       },
           :partial => 'shared/settings'

  project_module :gollum do
    permission :view_gollum_pages,   :gollum => [:index, :show]
    permission :add_gollum_pages,    :gollum => [:new, :create]
    permission :edit_gollum_pages,   :gollum => [:edit, :update]
    permission :delete_gollum_pages, :gollum => [:destroy]

    permission :manage_gollum_wiki, :gollum_wikis => [:index,:show, :update]
  end

  menu :project_menu, :gollum, { :controller => :gollum, :action => :index }, :caption => 'Gollum', :before => :wiki, :param => :project_id
end
