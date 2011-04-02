module GollumProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :project_settings_tabs, :gollum_tab
    end
  end

  module InstanceMethods
    # Adds a gollum tab to the project settings page
    def project_settings_tabs_with_gollum_tab
      tabs = project_settings_tabs_without_gollum_tab
      tabs << { :name => 'gollum', :action => :manage_gollum_wiki, :partial => 'gollum_wikis/edit', :label => 'Gollum' }
      tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    end
  end
end
