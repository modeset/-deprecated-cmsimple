class ImageExampleCell < Cell::Rails

  def display(snippet)
    @title = snippet.title
    @summary = snippet.summary
    @image_1 = snippet.image_1
    render view: :display
  end

  def preview(snippet)
    display(snippet)
  end

  def options(snippet)
    @snippet = snippet
    render
  end
end
