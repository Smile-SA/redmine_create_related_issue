require 'redmine'

require 'issue_relations_helper_patch'

Redmine::Plugin.register :redmine_create_related_issue do
  name 'Redmine Create Related Issue plugin'
  author 'Smile'
  description 'This plugin for Redmine allows you to directly create a related issue from another one.'
  version '0.0.1'
  url 'https://github.com/smile-oss/redmine_create_related_issue'
  author_url 'http://www.smile.fr/en/'

  Redmine::AccessControl.permissions.delete_if do |p|
    p.name == :manage_issue_relations || p.name == :add_issues
  end

  project_module :issue_tracking do |map|
    map.permission :manage_issue_relations, {:issue_relations => [:new, :destroy], :issues => :new_related}
    map.permission :add_issues, {:issues => [:new, :create, :update_form, :new_related]}
  end
end
