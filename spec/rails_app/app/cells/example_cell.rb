require 'ostruct'
class ExampleCell < Cell::Rails

  def display(snippet)
    @first_name = snippet.options['first_name']
    @last_name = snippet.options['last_name']
    render view: :display
  end

  def preview(snippet)
    display(snippet)
  end

  def options(snippet)
    @snippet = snippet
    @options = OpenStruct.new snippet.options
    render
  end

end
