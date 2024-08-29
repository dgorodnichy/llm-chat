import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.subscriptions.create("ChatChannel", {
  received(data) {
    document.getElementById("send-request").disabled = true;
    const chatBox = document.getElementById('chat-box');

    // Ищем div с data-status="pending"
    let botMessageElement = chatBox.querySelector('div[data-status="pending"]');

    // Если такого div нет, создаем новый
    if (!botMessageElement) {
      botMessageElement = document.createElement('div');
      botMessageElement.className = 'message bot';
      botMessageElement.setAttribute('data-status', 'pending');
      chatBox.appendChild(botMessageElement);
    }

    // Добавляем новое сообщение в существующий или новый div
    botMessageElement.textContent += ` ${data.message}`;

    // Если data.done = true, меняем статус на "done"
    if (data.done) {
      botMessageElement.setAttribute('data-status', 'done');
      document.getElementById("send-request").disabled = false;
    }

    // Прокручиваем чат вниз
    chatBox.scrollTop = chatBox.scrollHeight;
  }
});
