require_dependency 'issue_relations_helper'

module RedmineCreateRelatedIssue
  module IssueRelationsHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def project_select_tag
        options = []
        options << [l(:label_my_projects), 'my_projects'] unless User.current.memberships.empty?
        options << [l(:label_and_its_subprojects, @project.name), 'subprojects'] unless @project.nil? || @project.descendants.active.empty?
        options << [@project.name, @project.id] unless @project.nil?
        select_tag('project_id', options_for_select(options, params[:scope].to_s))
      end
    end
  end
end

IssueRelationsHelper.send(:include, RedmineCreateRelatedIssue::IssueRelationsHelperPatch)
