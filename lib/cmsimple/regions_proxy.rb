module Cmsimple
  class RegionsProxy
    attr_accessor :regions_hash

    def initialize(regions_hash)
      if regions_hash.is_a?(Hash)
        @regions_hash = ActiveSupport::HashWithIndifferentAccess.new(regions_hash.dup)
        define_regions
      end
    end

    def snippets_hash
      return {} unless @regions_hash.present?
      @regions_hash.inject(ActiveSupport::HashWithIndifferentAccess.new){|h, (k,v)| h.merge(v[:snippets].presence || {})}
    end

    def define_regions
      mod = Module.new
      extend mod

      region_methods = @regions_hash.collect do |key, value|
        %{def #{key}() Cmsimple::Region.new(@regions_hash[:#{key}]); end}
      end

      mod.module_eval region_methods.join("\n"), __FILE__, __LINE__ + 1
    end

    def method_missing method, *args, &block
      Region.new {}
    end
  end
end
