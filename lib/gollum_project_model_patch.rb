module GollumProjectModelPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
 
  module InstanceMethods
    def gollum_wiki
     return GollumWiki.first(:conditions => ["project_id = ?", self.id]) ||
            GollumWiki.new( :project_id => self.id,
                            :git_path => Setting.plugin_redmine_gollum[:gollum_base_path].to_s + "#{@project.identifier}.wiki.git".to_s)
    end
  end
end

