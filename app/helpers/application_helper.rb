module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def page_id
    "#{controller.controller_name}-#{controller.action_name}".dasherize
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        filter_html: true,
        no_links: true,
        safe_links_only: true,
        hard_wrap: true),
      underline: true,
      highlight: true,
      quote: true)
    @markdown.render(content)
  end

  def active_controller?(controller)
    "active" if params[:controller] == "admin/#{controller}"
  end
end
