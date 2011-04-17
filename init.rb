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
  name 'Redmine Gollum plugin'
  author 'Kang-min Liu <gugod@gugod.org>'
  description 'A gollum plugin for redmine'

  # use git to get version name
  require 'grit'
  repo = Grit::Repo.new("#{RAILS_ROOT}/vendor/plugins/redmine-gollum/.git")
  version repo.recent_tag_name('HEAD', :tags=>true)

  url 'https://github.com/gugod/redmine-gollum/'
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

    permission :manage_gollum_wiki, :gollum_wikis => [:index,:show, :create, :update]
  end

  menu :project_menu, :gollum, { :controller => :gollum, :action => :index }, :caption => 'Gollum', :before => :wiki, :param => :project_id
end
