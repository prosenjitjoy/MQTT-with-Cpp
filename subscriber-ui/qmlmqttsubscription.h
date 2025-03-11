#ifndef QMLMQTTSUBSCRIPTION_H
#define QMLMQTTSUBSCRIPTION_H

#include <QtQml/qqml.h>

#include <QObject>
#include <QtMqtt/QMqttClient>
#include <QtMqtt/QMqttSubscription>

class QmlMqttClient;

class QmlMqttSubscription : public QObject {
  Q_OBJECT
  Q_PROPERTY(QMqttTopicFilter topic MEMBER m_topic)
  QML_UNCREATABLE("Not intended to be creatable")

 public:
  QmlMqttSubscription(QMqttSubscription *s, QmlMqttClient *c);

 signals:
  void messageReceived(const QString &msg);

 public slots:
  void handleMessage(const QMqttMessage &qmsg);

 private:
  Q_DISABLE_COPY(QmlMqttSubscription)
  QMqttSubscription *sub;
  QmlMqttClient *client;
  QMqttTopicFilter m_topic;
};

class QmlMqttClient : public QObject {
  Q_OBJECT
  Q_PROPERTY(
      QString hostname READ hostname WRITE setHostname NOTIFY hostnameChanged)
  Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
  Q_PROPERTY(QMqttClient::ClientState state READ state WRITE setState NOTIFY
                 stateChanged)
  QML_NAMED_ELEMENT(MqttClient)

 public:
  QmlMqttClient(QObject *parent = nullptr);

  const QString hostname() const;
  void setHostname(const QString &newHostname);

  int port() const;
  void setPort(int newPort);

  QMqttClient::ClientState state() const;
  void setState(const QMqttClient::ClientState &newState);

 signals:
  void hostnameChanged();
  void portChanged();
  void stateChanged();

 public slots:
  void connectToHost();
  void disconnectFromHost();
  QmlMqttSubscription *subscribe(const QString &topic);

 private:
  Q_DISABLE_COPY(QmlMqttClient)
  QMqttClient m_client;
};

#endif // QMLMQTTSUBSCRIPTION_H
