import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MqttPublisher

Window {
  id: root
  width: 640
  height: 480
  visible: true
  title: qsTr("Qt Mqtt Publisher")

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
          client.disconnectedFromHost()
          messageModel.clear()
        } else {
          client.connectToHost()
        }
      }
    }

    GridLayout {
      enabled: client.state === MqttClient.Connected
      Layout.columnSpan: 4
      Layout.fillWidth: true
      columns: 6

      Label {
        text: "Topic:"
        color: "black"
      }

      TextField {
        id: pubField
        Layout.fillWidth: true
        placeholderText: "<Publication topic>"
      }

      Label {
        text: "Message:"
        color: "black"
      }

      TextField {
        id: msgField
        Layout.fillWidth: true
        placeholderText: "<Publication message>"
      }

      Label {
        text: "QoS:"
        color: "black"
      }

      ComboBox {
        id: qosItems
        Layout.fillWidth: true
        editable: true
        model: [0, 1, 2]
      }

      Label {
        text: "Retain:"
        color: "black"
      }

      CheckBox {
        id: retain
        checked: false
      }

      Button {
        id: pubButton
        Layout.columnSpan: 4
        Layout.fillWidth: true
        text: "Publish"
        onClicked: {
          if (pubField.text.length === 0 || msgField.text.length === 0) {
            console.log("No payload to send. Skipping publish...")
            return
          }
          client.publish(pubField.text, msgField.text, qosItems.currentIndex, retain.checked)
          root.addMessage(msgField.text)
          msgField.text = ""
        }
      }
    }

    ListView {
      id: messageView
      model: messageModel
      implicitHeight: 300
      implicitWidth: 200
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.columnSpan: 4
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
