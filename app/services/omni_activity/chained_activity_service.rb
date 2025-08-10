module OmniActivity
  module ChainedActivityService
    extend self

    DEFAULT_TRACKING_LEVELS = 2

    def generate(target:, actor:, name:, parent_id: nil, options: {})
      parent = parent_id.present? ? Activity.find_by(id: parent_id) : nil
      return parent if parent && ([parent.target, parent.actor, parent.name] == [target, actor, name])

      base_scope = Activity.where(target: target, actor: actor, name: name)
      matching_scope(base_scope, parent, options).first_or_create \
        parent_id: parent&.id,
        occurred_at: options[:occurred_at].presence,
        description: options[:description],
        options: options.except(:occurred_at, :description).except(:tracking_level)
    end

    private
      def matching_scope(base_scope, parent, options)
        join_sources = []
        (options[:tracking_level].presence || DEFAULT_TRACKING_LEVELS).to_i.times.map { |idx| Activity.arel_table.alias(get_activity_table_alias(idx)) }.each_cons(2).map.with_index do |(tp, tn), idx|
          nth_parent = parent&.nth_parent(idx)
          if nth_parent.nil?
            return base_scope.joins(join_sources).where(get_activity_table_alias(idx) => { parent_id: nil })
          else
            join_sources.push(
              tp.left.join(tn).on(
                tp[:parent_id].eq(tn[:id])
                .and(tn[:actor_id].eq(nth_parent&.actor_id))
                .and(tn[:actor_type].eq(nth_parent&.actor_type))
                .and(tn[:target_id].eq(nth_parent&.target_id))
                .and(tn[:target_type].eq(nth_parent&.target_type))
                .and(tn[:name].eq(nth_parent&.name))
              ).join_sources
            )
          end
        end
        base_scope.joins(join_sources)
      end

      def get_activity_table_alias(idx)
        idx.zero? ? Activity.table_name : "omni_activities_#{idx}"
      end
  end
end
