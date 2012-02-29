module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash

    belongs_to :parent, :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id'
    has_many :children, :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id', :dependent => :destroy

    validates :path,
              :title,
              :presence => true

    validates :path, :uniqueness => true

    before_validation :set_path

    def self.for_parent_select(page)
      scope = scoped
      unless page.new_record?
        scope = scope.where('id NOT IN (?)', page.descendants.map(&:id) + [page.id])
      end
      scope.all
    end

    def descendants
      children.all.inject([]) do |ary, child|
        ary << child
        ary + child.descendants
      end
    end

    def regions
      @regions ||= RegionsProxy.new(self.content)
    end

    def update_content(content)
      update_attributes(content: content)
    end

    def slug
      self[:slug] || escape(title)
    end

    protected

    def escape(string)
      result = string.to_s.dup
      result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result.gsub!(/[^\w_ \-]+/i, '') # Remove unwanted chars.
      result.gsub!(/[ \-]+/i, '-') # No more than one of the separator in a row.
      result.gsub!(/^\-|\-$/i, '') # Remove leading/trailing separator.
      result.downcase
    end

    def set_path
      self.path = [self.parent.try(:path), slug].join('/')
    end

  end
end
