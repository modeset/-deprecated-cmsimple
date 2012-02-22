module Cmsimple
  class Page < ActiveRecord::Base
    serialize :content, Hash

    belongs_to :parent, :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id'
    has_many :children, :class_name => '::Cmsimple::Page', :foreign_key => 'parent_id', :dependent => :destroy

    validates :path,
              :title,
              :presence => true

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

  end
end
