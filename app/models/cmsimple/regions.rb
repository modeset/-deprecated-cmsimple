module Cmsimple
  class Regions
    attr_accessor :regions_hash

    def initialize(regions_hash)
      if regions_hash.is_a?(Hash)
        @regions_hash = regions_hash.dup
        @regions_hash.symbolize_keys!
        define_regions
      end
    end

    def define_regions
      mod = Module.new
      extend mod

      region_methods = @regions_hash.collect do |key, value|
        %{def #{key}() Region.new(@regions_hash[:#{key}]); end}
      end

      mod.module_eval region_methods.join("\n"), __FILE__, __LINE__ + 1
    end

    def method_missing method, *args, &block
      NillRegion.new
    end

    class Region
      attr_reader :snippets
      def initialize(region_hash)
        @region_hash = region_hash.dup
        @region_hash.symbolize_keys!
        @snippets = []
        @html = value
        build_snippets
      end

      def build_snippets
        return unless @region_hash.key?(:snippets) && @region_hash[:snippets].is_a?(Hash)
        @snippets = @region_hash[:snippets].collect {|id, hash| Snippet.new(id, hash)}
      end

      def render_snippets
        @html = value
        snippets.each do |snippet|
          snippet_view = yield snippet
          @html.gsub!(snippet.matcher, snippet_view)
        end
      end

      def value
        @region_hash[:value]
      end

      def to_s
        @html.presence || ""
      end

    end

    class NillRegion
      def value; nil; end
      def render_snippets; nil; end
      def to_s; ""; end
    end

    class Snippet
      attr_accessor :name, :options, :id

      def initialize(id, snippet_hash)
        @id = id

        @snippet_hash = snippet_hash.dup
        @snippet_hash.symbolize_keys!

        @snippet_hash.each do |key, val|
          setter = "#{key}=".to_sym
          send(setter, val) if respond_to?(setter)
        end
      end

      def matcher
        /\[#{self.id}\/\d\]/
      end
    end
  end
end
