class AddOmniActivityActivitiesIndexOnParent < ActiveRecord::Migration[6.0]
  def change
    add_index :omni_activity_activities, :parent_id, name: "index_omni_activity_activities_on_parent"
  end
end
