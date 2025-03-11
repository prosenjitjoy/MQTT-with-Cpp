import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MqttSubscriber

Window {
  id: root
  visible: true
  width: 640
  height: 480
  title: qsTr("Qt Mqtt Subscriber")

  property var tempSubscription: 0

  MqttClient {
    id: client
    hostname: hostnameField.text
    port: portField.text
  }

  ListModel {
    id: messageModel
  }

  function addMessage(payload) {
    messageModel.insert(0, {
                          "payload": payload
                        })

    if (messageModel.count >= 100)
      messageModel.remove(99)
  }

  GridLayout {
    anchors.fill: parent
    anchors.margins: 10
    columns: 4

    Label {
      text: "Hostname:"
      color: "black"
      enabled: client.state === MqttClient.Disconnected
    }

    TextField {
      id: hostnameField
      Layout.fillWidth: true
      text: "test.mosquitto.org"
      placeholderText: "<Enter host running MQTT broker>"
      enabled: client.state === MqttClient.Disconnected
    }

    Label {
      text: "Port:"
      color: "black"
      enabled: client.state === MqttClient.Disconnected
    }

    TextField {
      id: portField
      Layout.fillWidth: true
      text: "1883"
      placeholderText: "<Port>"
      inputMethodHints: Qt.ImhDigitsOnly
      enabled: client.state === MqttClient.Disconnected
    }

    Button {
      id: connectButton
      Layout.columnSpan: 4
      Layout.fillWidth: true
      text: client.state === MqttClient.Connected ? "Disconnect" : "Connect"
      onClicked: {
        if (client.state === MqttClient.Connected) {
          client.disconnectFromHost()
          messageModel.clear()
          root.tempSubscription.destroy()
          root.tempSubscription = 0
        } else
          client.connectToHost()
      }
    }

    RowLayout {
      enabled: client.state === MqttClient.Connected
      Layout.columnSpan: 4
      Layout.fillWidth: true

      Label {
        text: "Topic:"
        color: "black"
      }

      TextField {
        id: subField
        placeholderText: "<Subscription topic>"
        Layout.fillWidth: true
        enabled: root.tempSubscription === 0
      }

      Button {
        id: subButton
        text: "Subscribe"
        enabled: root.tempSubscription === 0
        onClicked: {
          if (subField.text.length === 0) {
            console.log("No topic specified to subscribe to.")
            return
          }
          tempSubscription = client.subscribe(subField.text)
          tempSubscription.messageReceived.connect(addMessage)
        }
      }
    }

    ListView {
      id: messageView
      model: messageModel
      implicitHeight: 300
      implicitWidth: 200
      Layout.columnSpan: 4
      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      delegate: Rectangle {
        id: delegatedRectangle
        required property int index
        required property string payload
        width: ListView.view.width
        height: 30
        color: index % 2 ? "#DDDDDD" : "#888888"
        radius: 5
        Text {
          text: delegatedRectangle.payload
          anchors.centerIn: parent
        }
      }
    }

    Label {
      function stateToString(value) {
        switch (value) {
        case 0:
          return "Disconnected"
        case 1:
          return "Connecting"
        case 2:
          return "Connected"
        default:
          return "Unknown"
        }
      }

      Layout.columnSpan: 4
      Layout.fillWidth: true
      color: "#333333"
      text: "Status:" + stateToString(client.state) + "(" + client.state + ")"
      enabled: client.state === MqttClient.Connected
    }
  }
}
