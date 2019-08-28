module OmniActivity
  class Activity < ApplicationRecord
    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true,  optional: true

    belongs_to :parent, class_name: "OmniActivity::Activity", foreign_key: :parent_id, optional: true
    has_many :children, class_name: "OmniActivity::Activity", foreign_key: :parent_id, dependent: :destroy

    validates_presence_of :name, :occurred_at

    before_validation :auto_set_occurred_at, on: :create

    def root
      node = self
      node = node.parent while node.parent
      node
    end

    def nth_parent(n)
      node = self
      n.times do
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
