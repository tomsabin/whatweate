module ApplicationHelper
  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, { underline: true, highlight: true, quote: true })
    @markdown.render(content)
  end

  def active_controller?(controller)
    "active" if params[:controller] == "admin/#{controller}"
  end
end
