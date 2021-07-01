class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :current_location
  protect_from_forgery with: :null_session
  before_action :verify_auth_token
  before_action :set_active_storage_url
  
  
  rescue_from ActiveRecord::RecordNotFound do |error|
    api_error(400, error.message)
  end

  private

  def api_error(status = 500, errors = [], data = {})
    render json: { data: {}, type: 'Error', status: status, message: errors, data: data}, status: status
  end

  def api_success(status = 200, msg = [], data = {})
    render json: { data: data, type: 'Success', status: status, message: msg }, status: status
  end

  def collection_serializer(collection, serializer)
    ActiveModel::Serializer::CollectionSerializer.new(collection, serializer: serializer)
  end

  # def unauthenticated!
  #   response.headers['WWW-Authenticate'] = 'Token realm=Application'
  #   render json: { type: 'Error', message: "Please login to process further.", status: 410, data: {} }, status: 410
  # end

  def verify_auth_token
    @current_user = DeviseToken.find_by(auth_token: request.headers['TOKEN']).try(:user)
    if @current_user.present?
      @current_location = @current_user.location
    else
      api_error(410, 'Please login to process further.')
    end

    if @current_location.blank? && request.subdomain.present?
      @current_location = Location.find_by(subdomain: request.subdomain)
    end
  end

  def current_location
    @current_location ||= Location.find_by(subdomain: request.subdomain)
  end

  def set_active_storage_url
    Rails.application.routes.default_url_options[:host] = "https://#{request.subdomain}.#{ENV['CURRENT_SERVER_HOST']}"
  end

  def set_current_version
    return if params[:app_version].blank?
    @current_location ||= Location.find_by(subdomain: request.subdomain)
    return if @current_location.blank?
    @current_location.user.update_column(:current_version, params[:app_version])
  end
end
