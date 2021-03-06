Feature: The #mirror_rake_tasks DSL method with a defined task and renaming logic

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile defining a Ruby-method-shadowing task
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :load do |recipes|
          recipes.rename do |task_name|
            "do_#{task_name}"
          end
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap do_load # A task that shadows a Ruby method.
      """
    And the output should not contain "long"
    And the output should not contain "my_namespace"

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile defining a Ruby-method-shadowing task
    And a Capfile with:
      """
      set :current_path, '/current/path'

      Cape do
        mirror_rake_tasks :load do |recipes|
          recipes.rename do |task_name|
            "do_#{task_name}"
          end
        end
      end
      """
    When I run `cap do_load`
    Then the output should contain:
      """
        * executing `do_load'
      """
    And the output should contain:
      """
      `do_load' is only run for servers matching {}, but no servers matched
      """
