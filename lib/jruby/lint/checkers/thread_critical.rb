module JRuby::Lint
  module Checkers
    class ThreadCritical
      include Checker

      def check(collector)
        visitor = ::JRuby::Lint::AST::Visitor.new(collector.ast)
        visitor.method_calls_named("critical", "critical=").each do |node|
          begin
            if node.receiver_node.node_type.to_s == "CONSTNODE" && node.receiver_node.name == "Thread"
              add_finding(collector, node)
            end
          rescue
          end
        end
      end

      def add_finding(collector, node)
        collector.findings << Finding.new("Use of Thread.critical is discouraged. Use a Mutex instead.",
                                          [:threads, :warning], node.position)
      end
    end
  end
end