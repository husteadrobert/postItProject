module ApplicationHelper
  def fix_url(str)
    str.starts_with?('https://') ? str : "https://#{str}"
  end

  def fix_time(dt)
    dt.strftime("%d/%m/%Y %l:%M%P %Z") if dt
  end
end
