module Queries
  class Users < Queries::BaseQuery
    type [ObjectTypes::User], null: false

    def resolve
      ::User.all.order(:id)
    end
  end
end
