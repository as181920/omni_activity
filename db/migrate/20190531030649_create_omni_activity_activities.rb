class CreateOmniActivityActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :omni_activity_activities do |t|
      t.references :actor, polymorphic: true, index: { name: :index_omni_activity_activities_on_actor }
      t.references :target, polymorphic: true, index: { name: :index_omni_activity_activities_on_target }
      t.string :name, null: false
      t.datetime :occurred_at
      t.integer :parent_id
      t.text :description
      t.jsonb :options

      t.datetime :created_at
    end
  end
end
