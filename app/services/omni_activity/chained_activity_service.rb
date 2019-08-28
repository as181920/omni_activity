module OmniActivity
  module ChainedActivityService
    extend self

    DEFAULT_TRACKING_LEVELS = 2

    def generate(actor, previous_id, options={})
      previous = previous_id.present? ? Activity.find_by(id: previous_id) : nil

      if previous&.actor == actor
        previous
      else
        detect_matching_activity(actor, previous, options) || create_chained_activity(actor, previous, options)
      end
    end

    private
      def detect_matching_activity(actor, previous, options)
        base_scope = Activity.where(actor: actor)
        join_sources = []
        (options[:tracking_level].presence || DEFAULT_TRACKING_LEVELS).to_i.times.map{ |idx| Activity.arel_table.alias(get_activity_table_alias(idx)) }.each_cons(2).map.with_index do |(tp, tn), idx|
          nth_previous = previous&.nth_parent(idx)
          if nth_previous.nil?
            return base_scope.joins(join_sources).where(get_activity_table_alias(idx) => {parent_id: nil}).first
          else
            join_sources.push tp.left.join(tn).on(tp[:parent_id].eq(tn[:id]).and(tn[:actor_id].eq(nth_previous&.actor_id)).and(tn[:actor_type].eq(nth_previous&.actor_type))).join_sources
          end
        end
        base_scope.joins(join_sources).first
      end

      def create_chained_activity(actor, previous, options)
        Activity.create \
          parent_id: previous&.id,
          actor: actor,
          target: (options[:target] || previous.target),
          name: (options[:name].presence || previous.name),
          occurred_at: options[:occurred_at].presence,
          description: options[:description],
          options: options.except(:target, :name, :occurred_at, :description).except(:tracking_level)
      end

      def get_activity_table_alias(idx)
        idx.zero? ? Activity.table_name : "omni_activities_#{idx}"
      end
  end
end
