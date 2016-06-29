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
      connected: function() {},
      disconnected: function() {},
      received: function(data) {
        messages.append(data['message']);
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
      if ($.trim(textarea.val()).length > 1) {
        App.global_chat.send_message(textarea.val(), messages.data('complaint-id'));
        textarea.val('');
      }
      e.preventDefault();
      return false;
    });
  }
});
