import consumer from "./consumer"

document.addEventListener('turbo:load', function() {
  const messages = document.getElementById('messages');

  if (messages) {
    createRoomChannel(messages.dataset.roomId, messages.dataset.currentUserId, messages);
  }

  document.addEventListener('keypress', function(event) {
    if (event.target.id === 'message_body') {
      const message = event.target.value;
      if (event.key === 'Enter' && message.trim() !== '') {
        App.speak(message);
        event.target.value = '';
        event.preventDefault();
      }
    }
  });
});

function createRoomChannel(roomId, currentUserId, hold_messages) {
  App = consumer.subscriptions.create({ channel: 'RoomChannel', roomId: roomId, currentUserId: currentUserId }, {
    connected() {
      console.log('Connected to RoomChannel');
    },
    disconnected() {
      console.log('Disconnected from RoomChannel');
    },
    received(data) {
      const isCurrentUserMessage = data.user_id === parseInt(currentUserId);
      const messageContentClass = isCurrentUserMessage ? 'own-message' : '';

      if (data.action === 'room_deleted' && data.user_id !== parseInt(currentUserId)) {
        alert("Sorry:( This room is deleted...");
        window.location.href = "/";
      } else {
        const messageWrapper = document.createElement('div');
        messageWrapper.className = `message ${messageContentClass}`;
        messageWrapper.innerHTML = data.message;

        const messageTextElement = messageWrapper.querySelector('.message-text');
        if (messageTextElement) {
          messageTextElement.className = 'message-text rounded p-2';

          if (isCurrentUserMessage) {
            messageWrapper.querySelector('.message-sender').classList.add('text-end');
            messageWrapper.querySelector('.message-time').classList.add('text-end');
            messageTextElement.classList.add('bg-primary', 'text-white');
          } else {
            messageTextElement.classList.add('bg-light');
          }
        }

        hold_messages.appendChild(messageWrapper);
        hold_messages.scrollTop = hold_messages.scrollHeight;
      }
    },
    speak: function(message) {
      this.perform('speak', { message: message });
    }
  });
}
