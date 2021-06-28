module OmniActivity
  module TargetActable
    extend ActiveSupport::Concern

    included do
      has_many :activities, class_name: "::OmniActivity::Activity", as: :target, dependent: nil
    end
  end
end
