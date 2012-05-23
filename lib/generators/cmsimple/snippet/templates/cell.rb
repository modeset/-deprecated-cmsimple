class <%= class_name %>Cell < <%= options.base_snippet_class %>

  def display(snippet)
    <%- @fields.each do |field| -%>
    @<%= field %> = snippet.<%= field %>
    <%- end -%>
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
