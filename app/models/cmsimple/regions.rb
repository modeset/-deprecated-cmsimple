module Cmsimple
  class Regions
    attr_accessor :regions_hash

    def initialize(regions_hash)
      @regions_hash = regions_hash.dup
      @regions_hash.symbolize_keys!
      define_regions
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
      def initialize(region_hash)
        @region_hash = region_hash.dup
        @region_hash.symbolize_keys!
      end

      def value
        @region_hash[:value]
      end

      def to_s
        value.presence || ""
      end

    end

    class NillRegion
      def value; nil; end
      def to_s; ""; end
    end
  end
end
