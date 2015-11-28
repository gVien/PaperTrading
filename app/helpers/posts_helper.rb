module PostsHelper
  def post_content_of(post)
    # `html_safe` can be used in place of `raw` (raw uses html_safe behind the scene)
    post.content_html.nil? ? post.content : raw(post.content_html)
  end
end
