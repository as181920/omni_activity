class AddActableToOmniActivityActivities < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :omni_activity_activities, :actable, polymorphic: true, index: { unique: true, name: "index_omni_activity_activities_on_actable" }
  end
end
