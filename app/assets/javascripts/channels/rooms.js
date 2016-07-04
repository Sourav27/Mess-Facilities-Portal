jQuery(document).on('turbolinks:load', function() {
  var messages, messages_to_bottom;
  messages = $('#messages');
  if ($('#messages').length > 0) {
    messages_to_bottom = function() {
      return messages.scrollTop(messages.prop("scrollHeight"));
    };
    messages_to_bottom();
    App.global_chat = App.cable.subscriptions.create({
      channel: "ComplaintsChannel",
      complaint_id: messages.data('complaint-id')
    }, {
      connected: function() {
        console.log('Connected!');
      },
      disconnected: function() {
        console.log('Disconnected!');
      },
      received: function(data) {
        var reciever_id = $('meta[name=user-id]').attr("content");
        $html = $(data['message']);
        $id = data['user_id'];
        if(reciever_id == $id){
          $html.find(".card-block").addClass("self");  
        }
        else{
          $html.find(".card-block").addClass("other");
        }
        messages.append($html);
        return messages_to_bottom();
      },
      send_message: function(message, complaint_id) {
        return this.perform('send_message', {
          message: message,
          complaint_id: complaint_id
        });
      }
    });
    return $('#new_message').submit(function(e) {
      var $this, textarea;
      $this = $(this);
      textarea = $this.find('#message_body');
      if ($.trim(textarea.val()).length > 0) {
        App.global_chat.send_message(textarea.val(), messages.data('complaint-id'));
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });
  }
});
