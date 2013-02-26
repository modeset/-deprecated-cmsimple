module Cmsimple
  module Routing
    class PathConstraint
      def matches?(request)
        Cmsimple::PageNotFoundError.new
      end
    end
  end
end
