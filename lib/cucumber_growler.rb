require 'cucumber/formatters/pretty_formatter'

module CucumberGrowler
  IMAGE_ROOT = File.dirname(__FILE__) + '/../images'
  
  def self.included(base)    
    base.class_eval do
      alias original_dump dump
      include InstanceMethods

      def dump
        if @failed.length > 0
          gwl_fail "#{@failed.length} steps failed"
        elsif @pending.length > 0
          gwl_pending "#{@pending.length} steps pending, #{@passed.length} passed"
        else 
          gwl_pass "#{@passed.length} steps passed"
        end 
        original_dump
      end
      
    end    
  end
  
  module InstanceMethods
    def growl(title, msg, img, pri=0, sticky="")
      system "growlnotify -n 'Cucumber features' --image #{img} -p #{pri} -d '#{Time.now.to_s}' -m '#{msg}' #{title}"
    end

    def gwl_fail(message)
      growl("FAIL", message, "#{IMAGE_ROOT}/fail.png")
    end

    def gwl_pending(message)
      growl("PENDING", message, "#{IMAGE_ROOT}/pending.png")
    end

    def gwl_pass(message)
      growl("PASS", message, "#{IMAGE_ROOT}/pass.png")
    end       
  end 
end

class Cucumber::Formatters::PrettyFormatter
  include CucumberGrowler
end
