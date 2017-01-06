class PageSerializer < ActiveModel::Serializer
  attributes :id, :source, :content, :status
end