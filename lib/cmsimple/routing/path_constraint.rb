module Cmsimple
  module Routing
    class PathConstraint
      def matches?(request)
        !!Cmsimple::Path.from_request(request)
      end
    end
  end
end
