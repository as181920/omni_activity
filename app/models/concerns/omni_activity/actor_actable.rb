module OmniActivity
  module ActorActable
    extend ActiveSupport::Concern

    included do
      has_many :activities, class_name: "::OmniActivity::Activity", as: :actor, dependent: nil
    end
  end
end
