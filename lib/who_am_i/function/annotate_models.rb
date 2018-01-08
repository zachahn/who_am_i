module WhoAmI
  module Function
    class AnnotateModels
      include ProcParty

      def initialize(config, tables)
        @config = config
        @tables = tables
      end

      def call
        paths
          .flat_map(&Ls.new)
          .flat_map(&ParseModel.new)
          .tap(&ExtractModelData.new)
          .select(&:activerecord?)
          .reject(&:abstract_class?)
          .each(&ResolveTable.new(@tables))
          .reject(&:skipped?)
          .each(&ComputeComment.new)
          .reject(&:skipped?)
          .each(&ComputeContent.new)
          .reject(&:skipped?)
          .each(&WriteModel.new)
      end

      private

      def paths
        @config.annotate_models_paths
      end
    end
  end
end
