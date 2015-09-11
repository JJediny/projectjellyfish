class GroupsController < ApplicationController
  api :GET, '/groups', 'Returns a collection of groups'
  param :includes, Array, in: Group.reflect_on_all_associations.map(&:name).map(&:to_s)
  param :page, :number
  param :per_page, :number
  error code: 422, desc: ParameterValidation::Messages.missing

  def index
    authorize Group
    respond_with_params groups
  end

  api :GET, '/groups/:id', 'Shows group with :id'
  param :id, :number, required: true
  param :includes, Array, in: Group.reflect_on_all_associations.map(&:name).map(&:to_s)
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def show
    authorize group
    respond_with_params group
  end

  api :POST, '/groups', 'Creates group'
  param :name, String, desc: 'Group Name', required: true
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    group = Group.create group_params
    authorize group
    respond_with_params group
  end

  api :PUT, '/groups/:id', 'Updates group with :id'
  param :id, :number, required: true
  param :name, String, desc: 'Group Name'
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    authorize group
    group.update! group_params
    respond_with_params group
  end

  api :DELETE, '/groups/:id', 'Deletes group with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize group
    group.destroy
    respond_with_params group
  end

  private

  def group_params
    params.permit :name, :description, :staff_ids
  end

  def groups
    @_groups ||= query_with Group.all, :includes, :pagination
  end

  def group
    @_group ||= Group.find params[:id]
  end
end
