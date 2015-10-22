#ifndef NETWORKCOMM_H
#define NETWORKCOMM_H

#include <QObject>
#include<QtNetwork/QNetworkAccessManager>
#include<QtNetwork/QNetworkReply>
#include<QtNetwork/QNetworkRequest>
#include<QStringList>
#include<QThread>
#include<QUrlQuery>
class NetworkComm : public QThread
{
    Q_OBJECT
    Q_PROPERTY(QString token READ token WRITE setToken NOTIFY tokenChanged)
public:
    QNetworkAccessManager * nam;
    QNetworkReply * rply;
    QUrlQuery params;
    QHttpMultiPart *multiPart;
    QString s;
    QStringList rows;
    QStringList keys,values;
    QString m_token;
    void setToken(const QString &t);
    QString token();
    Q_INVOKABLE void sendGetRequest(QString);
    Q_INVOKABLE void sendPostRequest(QString);
    Q_INVOKABLE void addParam(QString,const QByteArray);
    Q_INVOKABLE void addImage(QString,const QByteArray);
    Q_INVOKABLE void addFile(QString,const QByteArray,const QByteArray,const QByteArray);
    explicit NetworkComm(QObject *parent = 0);

signals:
    void networkReply(const QString &network_reply_string);
    void networkSend();
    void tokenChanged();
public slots:
    void finishedSlot(QNetworkReply * t);
};

#endif // NETWORKCOMM_H
