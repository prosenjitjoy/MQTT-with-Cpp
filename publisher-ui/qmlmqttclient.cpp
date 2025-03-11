#include "qmlmqttclient.h"

#include <QMqttTopicName>

QmlMqttClient::QmlMqttClient(QObject *parent) : QObject(parent) {
  m_client.setProtocolVersion(QMqttClient::MQTT_5_0);
  connect(&m_client, &QMqttClient::hostnameChanged, this,
          &QmlMqttClient::hostnameChanged);
  connect(&m_client, &QMqttClient::portChanged, this,
          &QmlMqttClient::portChanged);
  connect(&m_client, &QMqttClient::stateChanged, this,
          &QmlMqttClient::stateChanged);
}

void QmlMqttClient::connectToHost() { m_client.connectToHost(); }

void QmlMqttClient::disconnectedFromHost() { m_client.disconnectFromHost(); }

int QmlMqttClient::publish(const QString &topic, const QString &message,
                           int qos, bool retain) {
  return m_client.publish(QMqttTopicName(topic), message.toUtf8(), qos, retain);
}

const QString QmlMqttClient::hostname() const { return m_client.hostname(); }

void QmlMqttClient::setHostname(const QString &newHostname) {
  m_client.setHostname(newHostname);
}

int QmlMqttClient::port() const { return m_client.port(); }

void QmlMqttClient::setPort(int newPort) {
  if (newPort < 0 || newPort > std::numeric_limits<quint16>::max()) {
    qWarning() << "Trying to set invalid port number";
    return;
  }
  m_client.setPort(static_cast<quint16>(newPort));
}

const QMqttClient::ClientState QmlMqttClient::state() const {
  return m_client.state();
}

void QmlMqttClient::setState(const QMqttClient::ClientState &newState) {
  m_client.setState(newState);
}
