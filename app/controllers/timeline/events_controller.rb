module Timeline
  class EventsController < ApplicationController
    load_and_authorize_resource class: Timeline::Event

    def create
    	@event = Timeline::Event.new(timeline_event_params)
      @event.text = "%%%" + @event.text
      @event.user_id = current_user.id
      @event.account_id = current_user.account_id
      @event.event_type = Timeline::EventType.lookup(:userevent)
  	
    	if !@event.save
    	
    	end
  	
      redirect_to request.referer + "#timeline"
    end

  private
      # Only allow a trusted parameter "white list" through.
      def timeline_event_params
        params.require(:timeline_event).permit(:text, :entity_id, :entity_type, :private)
      end
  end
end