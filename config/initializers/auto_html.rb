
# VIMEO CUSTOM FILTER
# wrap iframe in `div` in order to make video responsive when screen size is smaller
# source code:
# https://github.com/dejan/auto_html/blob/master/lib/auto_html/filters/vimeo.rb

AutoHtml.add_filter(:vimeo).with(:width => 440, :height => 248, :show_title => false, :show_byline => false, :show_portrait => false, :allow_fullscreen => false) do |text, options|
  text.gsub(/https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/) do
    vimeo_id = $2
    width  = options[:width]
    height = options[:height]
    show_title      = "title=0"    unless options[:show_title]
    show_byline     = "byline=0"   unless options[:show_byline]
    show_portrait   = "portrait=0" unless options[:show_portrait]
    allow_fullscreen = " webkitallowfullscreen mozallowfullscreen allowfullscreen" if options[:allow_fullscreen]
    frameborder     = options[:frameborder] || 0
    query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
    query_string    = "?" + query_string_variables unless query_string_variables.empty?

    # wrap iframe with `div`
    %{<div class="video vimeo"><iframe src="//player.vimeo.com/video/#{vimeo_id}#{query_string}" width="#{width}" height="#{height}" frameborder="#{frameborder}"#{allow_fullscreen}></iframe></div>}
  end
end