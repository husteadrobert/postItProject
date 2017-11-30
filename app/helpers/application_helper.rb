module ApplicationHelper
  def fix_url(str)
    str.starts_with?('https://') ? str : "https://#{str}"
  end

  def fix_time(dt)
    if logged_in? && !current_user.time_zone.blank?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%d/%m/%Y %l:%M%P %Z") if dt
  end
end
