module FseventsToVm
  class RecursionFilter
    attr_reader :recent_events
    
    def initialize
      @recent_events = {}
    end

    def ignore?(event)
      purge_old_events!
      existing_event = @recent_events[event.path]
      if existing_event && existing_event.mtime == event.mtime
        true
      else
        @recent_events[event.path] = event
        false
      end
    end

    private

    def purge_old_events!
      cutoff = Time.now - 30
      @recent_events.reject! { |path, event| event.event_time < cutoff }
    end
  end
end
