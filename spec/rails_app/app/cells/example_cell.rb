require 'ostruct'
class ExampleCell < Cell::Rails

  def display(snippet)
    @first_name = snippet.first_name
    @last_name = snippet.last_name
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
