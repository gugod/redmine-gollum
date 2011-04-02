module GollumProjectsControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :settings, :gollum_settings
    end
  end
 
  module InstanceMethods
    def settings_with_gollum_settings
      settings_without_gollum_settings
      # if a record not found, set some defaults
      @gollum_wiki =
         GollumWiki.first(:conditions => ["project_id = ?", @project.id]) ||
         GollumWiki.new( :project_id => @project.id,
                         :git_path => "some/default/path")
    end
  end
end

