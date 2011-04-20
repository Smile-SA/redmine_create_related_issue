require_dependency 'issues_controller'

class IssuesController < ApplicationController
  menu_item :new_issue, :only => [:new, :create, :new_related, :create_related]
  
  skip_before_filter :authorize, :only => [:new_related, :create_related]

  before_filter :find_project, :only => [:new, :create, :new_related, :create_related]
  before_filter :check_for_default_issue_status, :only => [:new, :create, :new_related, :create_related]
  before_filter :build_new_related_issue_from_params, :only => [:new_related, :create_related]
  accept_key_auth :index, :show, :create, :update, :destroy, :create_related

  def new_related
    respond_to do |format|
      format.html { render :template => 'issues/new_related.rhtml' }
    end
  end

  def create_related
    call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
    if @issue.save
      @relation.issue_from = @issue
      @relation.save

      attachments = Attachment.attach_files(@issue, params[:attachments])
      render_attachment_warning_if_needed(@issue)
      flash[:notice] = l(:notice_successful_create)
      call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
      respond_to do |format|
        format.html {
          redirect_to({ :action => 'show', :id => @issue })
        }
      end
      return
    else
      respond_to do |format|
        format.html { render :action => 'new_related' }
      end
    end
  end

  private

  def build_new_related_issue_from_params
    build_new_issue_from_params

    relation_params = params[:issue] ? params[:issue][:relation] : params[:relation]

    @relation = IssueRelation.new
    @relation.relation_type = relation_params[:relation_type]
    @relation.issue_to_id = relation_params[:issue_to_id]
    @relation.delay = relation_params[:delay]

    unless params[:issue]
      @relation.relation_type = IssueRelation::TYPES[relation_params[:relation_type]][:sym]
    end
  end
end
