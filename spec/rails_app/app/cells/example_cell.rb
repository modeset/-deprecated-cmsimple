class ExampleCell < Cell::Rails

  def display(snippet)
    @first_name = snippet.options['first_name']
    @last_name = snippet.options['last_name']
    render
  end

end
