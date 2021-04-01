import consumer from "./consumer"

consumer.subscriptions.create({channel: "UserDataChannel", id: 4}, {
  connected() {
    console.log("connected to InviteChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
  }
});
