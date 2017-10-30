require "./ameba/*"
require "./ameba/rules/*"

module Ameba
  extend self

  abstract struct BaseRule
    abstract def test(source : Source)
  end

  def run(formatter = DotFormatter.new)
    run Dir["**/*.cr"], formatter
  end

  def run(files, formatter : Formatter)
    sources = files.map { |path| Source.new(path) }

    reporter = Reporter.new formatter
    reporter.start sources
    sources.each do |source|
      catch(source)
      reporter.report source
    end
    reporter.try &.finish sources
  end

  def catch(source : Source)
    RULES.each do |rule|
      rule.new.test(source)
    end
  end
end