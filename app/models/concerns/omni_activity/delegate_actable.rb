module OmniActivity
  module DelegateActable
    extend ActiveSupport::Concern

    included do
      has_one :activity, class_name: "::OmniActivity::Activity", as: :actable, touch: true
    end
  end
end
