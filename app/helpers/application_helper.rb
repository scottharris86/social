module ApplicationHelper

  def flash_class(type)
    case type
    when "alert"
      "alert-error"
    when "notice"
      "alert-info"
    end
  end
end
