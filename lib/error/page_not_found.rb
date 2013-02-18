module Cmsimple
  module Error
    class PageNotFound < StandardError
      def initialize(route)
        message = "'#{route}' is not a viewable page"
        super(message)
      end
    end
  end
end
