module TagsHelper
  def color_palette(*colors)
    content_tag(:ul) do
      colors.map do |color|
        content_tag(:li) do
          content_tag(:span, nil, class: "color-swatch", style: "background: #{color}") +
          content_tag(:span, color, class: "color-label")
        end
      end.join.html_safe
    end
  end
end
