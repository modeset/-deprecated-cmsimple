class Cmsimple::ApiResponder < ActionController::Responder

  def json_resource_errors
    errors = super
    errors[:error_message] = resource.errors.full_messages.to_sentence
    errors
  end

  def api_behavior
    raise error unless resourceful?

    if get?
      display resource
    elsif post?
      display resource, :status => :created, :location => api_location
    # we want to always return the resource for updates
    elsif put?
      display resource, :status => :ok
    else
      head :no_content
    end
  end

  def display_errors
    controller.render format => resource_errors, :status => delete? ? :forbidden : :unprocessable_entity
  end

end
