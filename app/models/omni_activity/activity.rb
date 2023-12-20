module OmniActivity
  class Activity < ApplicationRecord
    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true, optional: true

    belongs_to :parent, class_name: "OmniActivity::Activity", foreign_key: :parent_id, optional: true
    has_many :children, class_name: "OmniActivity::Activity", foreign_key: :parent_id, dependent: nil

    validates :name, :occurred_at, presence: true

    before_validation :auto_set_occurred_at, on: :create

    def self.ransackable_attributes(_auth_object = nil)
      %w[id actor_type actor_id target_type target_id name occurred_at description parent_id]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[actor target]
    end

    def root
      node = self
      node = node.parent while node.parent
      node
    end

    def nth_parent(nth_number)
      node = self
      nth_number.times do
        node = node.parent
        break node if node.nil?
      end
      node
    end

    private

      def auto_set_occurred_at
        self.occurred_at ||= Time.zone.now
      end
  end
end
