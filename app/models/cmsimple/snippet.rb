module Cmsimple
    class Snippet
      extend ActiveModel::Naming
      attr_accessor :name, :options, :id

      def initialize(id, snippet_hash)
        @id = id

        @snippet_hash = snippet_hash.dup
        # @snippet_hash.symbolize_keys!

        @name = @snippet_hash[:name]
        @options = flatten_options(@snippet_hash[:options])
      end

      def flatten_options(options)
        return {} unless options.present?
        options = options.dup
        if options.key?(:snippet)
          options.merge(options[:snippet])
        else
          options
        end
      end

      def method_missing method, *args, &block
        @options[method]
      end

      def matcher
        /\[#{self.id}(\/\d)?\]/
      end

      #
      # ActiveModel API
      #
      def persisted?
        false
      end

      def to_param
        nil
      end

      def to_key
        nil
      end

      def to_partial_path
        "cmsimple/snippets/#{name}/display"
      end

      def errors
        ActiveModel::Errors.new(self)
      end

      def valid?
        true
      end
    end
end
