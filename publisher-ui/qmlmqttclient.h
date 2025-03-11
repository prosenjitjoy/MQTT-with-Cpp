#ifndef QMLMQTTCLIENT_H
#define QMLMQTTCLIENT_H

#include <QtQml/qqml.h>

#include <QObject>
#include <QtMqtt/QMqttClient>

class QmlMqttClient : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString hostname READ hostname WRITE setHostname NOTIFY
                 hostnameChanged FINAL)
  Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged FINAL)
  Q_PROPERTY(QMqttClient::ClientState state READ state WRITE setState NOTIFY
                 stateChanged FINAL)
  QML_NAMED_ELEMENT(MqttClient)

 public:
  QmlMqttClient(QObject *parent = nullptr);

  const QString hostname() const;
  void setHostname(const QString &newHostname);

  int port() const;
  void setPort(int newPort);

  const QMqttClient::ClientState state() const;
  void setState(const QMqttClient::ClientState &newState);

 signals:
  void hostnameChanged();
  void portChanged();
  void stateChanged();

 public slots:
  void connectToHost();
  void disconnectedFromHost();
  int publish(const QString &topic, const QString &message, int qos = 0,
              bool retain = false);

 private:
  Q_DISABLE_COPY(QmlMqttClient)
  QMqttClient m_client;
};

#endif // QMLMQTTCLIENT_H
