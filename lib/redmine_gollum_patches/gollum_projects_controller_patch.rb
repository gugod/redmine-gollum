require_dependency 'projects_controller'

module RedmineGollum
  module Patches
    module ProjectsController

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :settings, :gollum_settings
    end
  end
 
  module InstanceMethods
    def settings_with_gollum_settings
      settings_without_gollum_settings
      @gollum_wiki = @project.gollum_wiki
    end
  end

    end
  end
end
