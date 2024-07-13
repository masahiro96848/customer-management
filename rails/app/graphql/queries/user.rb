module Queries
  class User < Queries::BaseQuery
    argument :id, ID, required: true

    type ObjectTypes::User, null: false

    def resolve(id:)
      ::User.find(id)
    end
  end
end
