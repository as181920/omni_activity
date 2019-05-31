require "omni_activity/engine"

module OmniActivity
  extend ActiveSupport::Concern

  included do
    has_many :activities, class_name: "::OmniActivity::Activity", as: :actor, dependent: :destroy
  end
end
