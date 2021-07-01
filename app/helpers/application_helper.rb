# frozen_string_literal: true
include ActiveSupport::NumberHelper
module ApplicationHelper
  ACTIVE_STRING = 'active'
  LINK_ACTIVE_ACTIONS = {}.freeze
  ACTIVE_MENU_ACTIONS = {
    dashboard: [%w[dashboard index]]}.freeze
  ACTIVE_SUB_MENU_ACTIONS = {
    # category: [%w[categories index],
    #            %w[categories new],
    #            %w[categories edit]]]
  }.freeze


  def user_location(_user, id_only = false)
    id_only ? current_user.location.id : current_user.location
  end

  def active_link_class(link_text)
    unless LINK_ACTIVE_ACTIONS[link_text].present? && LINK_ACTIVE_ACTIONS[link_text].include?([params[:controller], params[:action]])
      return
    end

    ACTIVE_STRING
  end

  def active_menu_class(menu_text)
    unless ACTIVE_MENU_ACTIONS[menu_text].present? && ACTIVE_MENU_ACTIONS[menu_text].include?([params[:controller], params[:action]])
      return
    end

    ACTIVE_STRING
  end

  def active_sub_menu_class(menu_text)
    unless ACTIVE_SUB_MENU_ACTIONS[menu_text].present? && ACTIVE_SUB_MENU_ACTIONS[menu_text].include?([params[:controller], params[:action]])
      return
    end

    ACTIVE_STRING
  end

  def active_report_menu_class(action)
    unless (params[:controller] == 'reports' && action == params[:action]) || (params[:controller] == 'employees' && action == params[:action])
      return
    end

    ACTIVE_STRING
  end

  def active_eats_sub_menu_class(action)
    unless (params[:controller] == 'pages' && action == params[:action]) || (params[:controller] == 'preview_venue_informations' && action == params[:action]) ||
           (params[:controller] == 'locations' && action == params[:action])
      return
    end

    ACTIVE_STRING
  end

  def active_admin_location_class(action)
    return unless params[:controller] == 'admin/locations' && action == params[:action] && action != 'assign_venue'

    ACTIVE_STRING
  end

  def active_super_admin_class
    return unless params[:controller] == 'reports' && action == params[:action]

    ACTIVE_STRING
  end

  def active_sub_menu_with_same_path(_action)
    unless (params[:controller] == 'reports' && params[:action] == 'employee_report') || (params[:controller] == 'reports' && params[:action] == 'employee_report_detail')
      return
    end

    ACTIVE_STRING
  end

  def display_two_digit(val)
    val = val.to_f
    val = (val < 0) ? 0 : val
    # number_to_delimited('%.2f' % val.to_f)
    '%.2f' % val.to_f
  end

  def display_one_digit(val)
    val = val.to_f
    val = (val < 0) ? 0 : val
    '%.1f' % val.to_f
  end

  def display_two_digit_with_dlr(val)
    val = val.to_f
    val = (val < 0) ? 0 : val
    # number_to_delimited('%.2f' % val.to_f)
    "$#{'%.2f' % val.to_f}"
  end

  def display_two_digit_with_delimiter(val)
    val = val.to_f
    val = (val < 0) ? 0 : val
    number_to_delimited('%.2f' % val.to_f)
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert-success'
    when 'success' then 'alert-success'
    when 'error' then 'alert-error'
    when 'alert' then 'alert-error'
    end
  end

  def error_messages(object)
    messages = object.errors.messages.collect do |key, value|
      key_text = key.to_s
      field = (key_text.include?('.') ? key_text.split('.').last : key_text).titleize
      value.collect { |message| "#{field} #{message}" }
    end
    messages.uniq.join(', ')
  end

  def error_messages_only(object)
    messages = object.errors.messages.collect do |key, value|
      value.collect { |message| "#{message}" }
    end
    messages.uniq.join(', ')
  end
end
