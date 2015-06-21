module ApplicationHelper
  def page_id
    "#{controller.controller_name}-#{controller.action_name}".dasherize
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, { underline: true, highlight: true, quote: true })
    @markdown.render(content)
  end

  def active_controller?(controller)
    "active" if params[:controller] == "admin/#{controller}"
  end

  def javascript_require(*modules)
    javascript_tag modules.map { |m| "require('#{m}');" }.join("\n")
  end
end
