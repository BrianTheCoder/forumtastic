require 'paginate/collection'
require 'dm-aggregates'

module Paginate
  module Finder
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def paginate(options = {})
        page = (options.delete(:page) || 1).to_i
        per_page = options.delete(:per_page) || 20
        total = self.count(options.except(:order))
        offset = (page - 1) * per_page
        collection = Paginate::Collection.new(page,per_page,total)
        collection.replace self.all(options.merge(:limit=>per_page,:offset=>offset))
      end
    end
  end
end