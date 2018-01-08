module WhoAmI
  class Config
    using Refinement::HashDig

    def initialize(config)
      @internal = config
      @defaults = {
        autorun_enabled: true,
        autorun_after_tasks: [
          "db:migrate",
        ],
        load_environment_enabled: true,
        load_environment_approach: :rake,
        load_environment_rake_task: "environment",
        load_environment_manual_database: "",
        load_environment_manual_initializers: [
          "config/initializers/inflections.rb",
        ],
        annotate_models_enabled: true,
        annotate_models_paths: [
          "app/models/**/*.rb",
        ],
      }
    end

    def autorun_enabled?
      enabled = @internal.dig(:autorun, :enabled)

      if enabled.nil?
        @defaults[:autorun_enabled]
      else
        !!enabled
      end
    end

    def autorun_after_tasks
      @internal.dig(:autorun, :rake) || @defaults[:autorun_after_tasks]
    end

    def load_environment?
      @internal.dig(:environment, :enabled)

      if enabled.nil?
        @defaults[:load_environment_enabled]
      else
        !!enabled
      end
    end

    def load_environment_approach
      approach =
        @internal.dig(:environment, :approach) ||
          @defaults[:load_environment_approach]

      approach.to_sym
    end

    def load_environment_rake_task
      @internal.dig(:environment, :rake, :task) ||
        @defaults[:load_environment_rake_task]
    end

    def load_environment_manual_database
      @internal.dig(:environment, :manual, :database) ||
        @defaults[:load_environment_manual_database]
    end

    def load_environment_manual_initializers
      @internal.dig(:environment, :manual, :initializers) ||
        @defaults[:load_environment_manual_initializers]
    end

    def annotate_models?
      enabled = @internal.dig(:annotate, :models, :enabled)

      if enabled.nil?
        @defaults[:annotate_models_enabled]
      else
        !!enabled
      end
    end

    def annotate_models_paths
      @internal.dig(:annotate, :models, :paths) ||
        @defaults[:annotate_models_paths]
    end
  end
end
