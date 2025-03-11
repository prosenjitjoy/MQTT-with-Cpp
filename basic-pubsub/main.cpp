#include <QCoreApplication>
#include <QtMqtt>

int main(int argc, char *argv[]) {
  QCoreApplication a(argc, argv);

  QMqttClient client;
  client.setProtocolVersion(QMqttClient::MQTT_5_0);
  client.setHostname("127.0.0.1");
  client.setPort(1883);

  a.connect(&client, &QMqttClient::connected, &client, [&client]() {
    qDebug() << "Connected:";
    const auto serverProp = client.serverConnectionProperties();
    const auto available = serverProp.availableProperties();
    if (available & QMqttServerConnectionProperties::MaximumPacketSize) {
      qDebug() << "Max Packet Size:" << serverProp.maximumPacketSize();
    }
    if (available && QMqttServerConnectionProperties::MaximumTopicAlias) {
      qDebug() << "Max Topic Alias:" << serverProp.maximumTopicAlias();
    }

    QMqttSubscriptionProperties subProps;
    subProps.setSubscriptionIdentifier(42);
    auto sub = client.subscribe(QString("topics/some"), subProps, 1);

    sub->connect(
        sub, &QMqttSubscription::messageReceived, [](const QMqttMessage &msg) {
          qDebug() << "Message Received:" << msg.payload();
          qDebug() << "Topic Alias:" << msg.publishProperties().topicAlias();
          qDebug() << "Response Topic:"
                   << msg.publishProperties().responseTopic();
        });

    client.connect(sub, &QMqttSubscription::stateChanged, &client,
                   [&client](QMqttSubscription::SubscriptionState s) {
                     qDebug() << "Subscription new State:" << s;

                     QMqttPublishProperties pubProps;
                     pubProps.setResponseTopic(QString("please/reply/here"));
                     pubProps.setTopicAlias(1);
                     client.publish(QString("topics/some"), pubProps, "foo", 1);
                   });
  });

  QMqttConnectionProperties conProp;
  conProp.setMaximumPacketSize(256);
  conProp.setMaximumTopicAlias(5);
  client.setConnectionProperties(conProp);
  client.connectToHost();

  return a.exec();
}
